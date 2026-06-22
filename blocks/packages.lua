-- packages blocks

return {
	name = "packages",
	interval = nil,
	signal = 4,
	update = function()
		local f = io.open(require("config").packages_path)
		if not f then
			return ""
		end
		return f:read()
	end,
}
