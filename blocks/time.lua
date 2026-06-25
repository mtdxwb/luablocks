-- time blocks

local icons = {
	["01"] = "󱐿 ",
	["02"] = "󱑀 ",
	["03"] = "󱑁 ",
	["04"] = "󱑂 ",
	["05"] = "󱑃 ",
	["06"] = "󱑄 ",
	["07"] = "󱑅 ",
	["08"] = "󱑆 ",
	["09"] = "󱑇 ",
	["10"] = "󱑈 ",
	["11"] = "󱑉 ",
	["12"] = "󱑊 ",
}

local M = {
	command = function()
		local hour_icon = icons[os.date("%I")]
		return hour_icon .. os.date("%H:%M")
	end,
}

return M
