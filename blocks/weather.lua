-- weather blocks

return {
	command = function()
		local f = io.open(require("config").home .. "/.cache/wttr.status")
		local weather = ""

		if f then
			weather = f:read()
			io.close(f)
		end
		return weather
	end,
}
