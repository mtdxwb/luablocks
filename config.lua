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
	modules_order = { "cpu", "temp", "packages", "battery", "volume", "backlight", "weather", "time" },

	-- backlight_cards
	backlight_cards = { "nvidia_0", "amdgpu_bl0", "amdgpu_bl1", "amdgpu_bl2" },

	battery_path = "/sys/class/power_supply/BAT0",
	wttr_path = os.getenv("HOME") .. "/.cache/wttr.status",
	packages_path = os.getenv("HOME") .. "/.cache/checkupdates-cron.status",

	output_mode = "stdout", -- or "xsetroot" / "fifo"
}
