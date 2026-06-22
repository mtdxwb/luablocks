-- weather blocks

return {
	name = "weather",
	interval = nil,
	signal = 5,
	update = function()
		local f = io.open(require("config").home .. "/.cache/wttr.status")
		local weather = ""

		if f then
			weather = f:read()
			io.close(f)
		end
		return weather
	end,
}
