-- bat blocks

local M = {
	name = "battery",
	interval = 15,
	signal = nil,
	update = function()
		local icons = {
			["1"] = "󰁻",
			["2"] = "󰁼",
			["3"] = "󰁽",
			["4"] = "󰁽",
			["5"] = "󰁾",
			["6"] = "󰁿",
			["7"] = "󰂀",
			["8"] = "󰂁",
			["9"] = "󰂂",
			["10"] = "󰁹",
		}

		local status = ""
		local level = ""
		local bat_icon = ""

		local f1 = io.open(require("config").battery_path .. "/status", "r")
		local f2 = io.open(require("config").battery_path .. "/capacity", "r")

		if f1 and f2 then
			status = f1:read()
			level = f2:read()
			io.close(f1)
			io.close(f2)
		end

		if status == "Discharging" then
			bat_icon = level:sub(1, -2) == nil and "󰁺" or icons[level:sub(1, -2)]
		elseif status == "Not charging" or status == "Full" then
			bat_icon = " "
		elseif status == "Charging" then
			bat_icon = " "
		end

		return bat_icon .. level .. "%"
	end,
}

return M
