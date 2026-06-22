#!/usr/bin/env lua

-- vim:ft=lua
-- @author Dongxu Zhu
-- @since 2026
--
-- need: lua-posix

-- lua-posix
local posix = require("posix")
local signal = require("posix.signal")
local fcntl = require("posix.fcntl")

-- bash -> export LUABLOCKS_CONFIG=~/.config/luablocks
local config_dir = os.getenv("LUABLOCKS_CONFIG") or (os.getenv("HOME") .. "/.config/luablocks")
package.path = config_dir .. "/blocks/?.lua;" .. config_dir .. "/?.lua;" .. package.path

local config = require("config")

-- pid
local pid = posix.getpid().pid
local pid_file = io.open(config.runtime_dir .. "/luablocks.pid", "w")
pid_file:write(pid)
io.close(pid_file)

local fifo_path = config.runtime_dir .. "/luablocks.fifo"
local fifo_file

-- [[
-- modes:
-- -> like luablocks [-s | --stdout] => mode = "stdout"
-- ]]
local modes = {
	["stdout"] = function(stdout)
		print(string.format("[%s]", stdout))
	end,
	["xsetroot"] = function(stdout)
		os.execute("xsetroot -name '[" .. stdout .. "]'")
	end,
	["fifo"] = function(stdout)
		fifo_file:write("[" .. stdout .. "]\n")
		fifo_file:flush()
	end,
}
local arg_to_mode = {
	["-s"] = "stdout",
	["--stdout"] = "stdout",
	["-f"] = "fifo",
	["--fifo"] = "fifo",
	["-x"] = "xsetroot",
	["--xsetroot"] = "xsetroot",
}
config.output_mode = arg[1] == nil and "stdout" or arg_to_mode[arg[1]]

-- fifo
if config.output_mode == "fifo" then
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
	local stdout = table.concat(parts, "][") -- custom sep
	modes[config.output_mode](stdout)
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
