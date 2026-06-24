#!/usr/bin/env lua

-- vim:ft=lua
-- @author Dongxu Zhu
-- @since 2026
--
-- need: lua-posix

-- arg
local help_text = [[

Usage: luablocks [OPTION]

Options:
  -s, --stdout       Print status bar to stdout (default)
  -f, --fifo         Write to FIFO (useful for dwm/other bars)
  -x, --xsetroot     Set X root window name (for dwm)
  -h, --help         Show this help message

Examples:
  luablocks -s       Print to stdout
  luablocks -f       Write to $XDG_RUNTIME_DIR/luablocks.fifo
  luablocks -x       Set xsetroot name
]]

local arg_to_mode = {
	["-s"] = "stdout",
	["--stdout"] = "stdout",
	["-f"] = "fifo",
	["--fifo"] = "fifo",
	["-x"] = "xsetroot",
	["--xsetroot"] = "xsetroot",
}

local function parse_args()
	if arg[2] ~= nil then
		io.stderr:write("* Err: too many args!\n")
		os.exit()
	end

	if arg[1] == nil or arg[1] == "-h" or arg[1] == "--help" then
		io.stdout:write(help_text .. "\n")
		os.exit()
	end

	if arg_to_mode[arg[1]] == nil then
		io.stderr:write("* Err: args is wrong!\n")
		os.exit()
	else
		return arg_to_mode[arg[1]]
	end
end

-- bash -> export LUABLOCKS_CONFIG=~/.config/luablocks
local config_dir = os.getenv("LUABLOCKS_CONFIG") or (os.getenv("HOME") .. "/.config/luablocks")
package.path = config_dir .. "/blocks/?.lua;" .. config_dir .. "/?.lua;" .. package.path

local config = require("config")

local mode = parse_args()

-- lua-posix
local posix = require("posix")
local signal = require("posix.signal")

-- pid
-- local pid = posix.getpid().pid
-- local pid_file = io.open(config.runtime_dir .. "/luablocks.pid", "w")
-- pid_file:write(pid .. "\n")
-- io.close(pid_file)

local fifo_path = config.runtime_dir .. "/luablocks.fifo"
local fifo_file

-- [[
-- modes:
-- -> like luablocks [-s | --stdout] => mode = "stdout"
-- ]]
local modes = {
	["stdout"] = function(stdout)
		io.stdout:write(stdout .. "\n")
		io.stdout:flush()
	end,
	["xsetroot"] = function(stdout)
		os.execute("xsetroot -name '" .. stdout .. "'")
	end,
	["fifo"] = function(stdout)
		fifo_file:write(stdout .. "\n")
		fifo_file:flush()
	end,
}

-- fifo
if mode == "fifo" then
	local is_file = posix.stat(fifo_path)

	if is_file then
		os.remove(fifo_path)
	end
	posix.mkfifo(fifo_path)

	fifo_file = io.open(fifo_path, "w")
end

local module_list = {} -- store in order
for _, mod_name in ipairs(config.modules_order) do
	local mod = require(mod_name)
	mod.last_update = 0
	mod.cached_output = ""
	table.insert(module_list, mod)
end

local function display()
	local parts = {}
	for _, mod in ipairs(module_list) do
		if mod.cached_output and mod.cached_output ~= "" then
			table.insert(parts, mod.cached_output)
		end
	end
	local stdout = string.format("%s%s%s", config.head, table.concat(parts, config.sep), config.tail) -- custom sep
	modes[mode](stdout)
end

for _, mod in ipairs(module_list) do
	mod.cached_output = mod.update() or ""
end
display()

-- signal
for _, mod in ipairs(module_list) do
	if mod.signal then
		signal.signal(config.signal + mod.signal, function()
			mod.cached_output = mod.update() or ""
			display()
		end)
	end
end

local sec = 0

while true do
	posix.sleep(1)
	sec = sec + 1

	local need_redraw = false
	for _, mod in ipairs(module_list) do
		if mod.interval and sec % mod.interval == 0 then
			mod.cached_output = mod.update() or ""
			need_redraw = true
		end
	end

	if need_redraw then
		display()
	end
end
