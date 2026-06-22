-- volume blocks

local M = {
	name = "volume",
	interval = nil,
	signal = 1,
	update = function()
		local command1 = io.popen("[ $(pamixer --get-mute) = 'false' ] && printf '🔊' || printf '🔇'")
		local command2 = io.popen("pamixer --get-volume")
		local volume = ""

		if command1 and command2 then
			volume = command1:read() .. command2:read() .. "%"
			io.close(command1)
			io.close(command2)
		end

		return volume
	end,
}

return M
