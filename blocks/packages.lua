-- packages blocks

return {
	command = function()
		local f = io.open(require("config").packages_path)
		if not f then
			return ""
		end
		return f:read()
	end,
}
