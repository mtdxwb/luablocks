-- backlight blocks

local M = {
	name = "backlight",
	interval = nil,
	signal = 2,
	update = function()
		local icons = {
			["1"] = "󱩎 ",
			["2"] = "󱩏 ",
			["3"] = "󱩐 ",
			["4"] = "󱩑 ",
			["5"] = "󱩒 ",
			["6"] = "󱩓 ",
			["7"] = "󱩔 ",
			["8"] = "󱩕 ",
			["9"] = "󱩖 ",
			["10"] = "󰛨 ",
		}
		local cards = require("config").backlight_cards
		local card = ""
		for i = 1, #cards do
			local is_dir = require("posix").stat("/sys/class/backlight/" .. cards[i])
			if is_dir then
				card = cards[i]
				break
			end
		end

		local f1 = io.open("/sys/class/backlight/" .. card .. "/actual_brightness", "r")
		local f2 = io.open("/sys/class/backlight/" .. card .. "/max_brightness", "r")
		local result = ""

		if f1 and f2 then
			result, _ = math.modf(tonumber(f1:read()) * 100 / tonumber(f2:read()))
			io.close(f1)
			io.close(f2)
		end

		local level = tostring(result)
		return level:sub(1, -2) == nil and "󰛩 " .. result .. "%" or icons[level:sub(1, -2)] .. result .. "%"
	end,
}

return M
