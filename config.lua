return {
	-- vars
	runtime_dir = os.getenv("XDG_RUNTIME_DIR") or "/tmp",
	home = os.getenv("HOME"),

	-- format = function(m_table, sep, head, tail)
	sep = "][",
	head = "[",
	tail = "]",

	-- signal set
	signal = require("posix.signal").SIGRTMIN or 34,
	-- display order
	blocks_order = { "cpu", "memory", "temp", "packages", "battery", "volume", "backlight", "weather", "time" },

	blocks = {
		-- lua blocks
		cpu = {
			type = "lua",
			interval = 15,
			signal = nil,
			command = require("cpu").command,
		},
		time = {
			type = "lua",
			interval = 5,
			signal = nil,
			command = require("time").command,
		},
		packages = {
			type = "lua",
			interval = nil,
			signal = 4,
			command = require("packages").command,
		},
		temp = {
			type = "lua",
			interval = 5,
			signal = nil,
			command = require("temp").command,
		},
		weather = {
			type = "lua",
			interval = nil,
			signal = 5,
			command = require("weather").command,
		},
		battery = {
			type = "lua",
			interval = 15,
			signal = nil,
			command = require("battery").command,
		},
		backlight = {
			type = "lua",
			interval = nil,
			signal = 2,
			command = require("backlight").command,
		},

		-- external blocks
		volume = {
			type = "external",
			interval = nil,
			signal = 1,
			command = [[printf "%s%s" $([ "$(pamixer --get-mute)" = "false" ] && printf '🔊' || printf '🔇') $(pamixer --get-volume)%]],
		},
		memory = { -- name
			type = "external",
			command = [[free -h | sed -n "2s/\([^ ]* *\)\{2\}\([^ ]*\).*/\2/p"]], -- script path
			interval = 15,
			signal = nil,
		},
	},

	-- backlight_cards
	backlight_cards = { "nvidia_0", "amdgpu_bl0", "amdgpu_bl1", "amdgpu_bl2" },

	battery_path = "/sys/class/power_supply/BAT0",
	wttr_path = os.getenv("HOME") .. "/.cache/wttr.status",
	packages_path = os.getenv("HOME") .. "/.cache/checkupdates-cron.status",
	temp_path = "/sys/class/thermal/thermal_zone0/temp",
}
