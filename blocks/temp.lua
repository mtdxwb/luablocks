-- temp blocks

local M = {
	name = "temp",
	interval = 5,
	signal = nil,
	update = function()
		local temp_file = io.open("/sys/class/thermal/thermal_zone0/temp", "r")
		local temp_icon = ""
		local temp_num = ""
		if temp_file then
			temp_num = temp_file:read():gsub("000", "")
			io.close(temp_file)
		end

		if temp_num == nil then
			temp_icon = "󱔱"
			temp_num = ""
		end

		return temp_icon .. temp_num .. "℃"
	end,
}

return M
