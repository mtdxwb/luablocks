-- temp blocks

local M = {
	command = function()
		local temp_file = io.open(require("config").temp_path, "r")
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
