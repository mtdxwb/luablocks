return {
	-- vars
	runtime_dir = os.getenv("XDG_RUNTIME_DIR") or "/tmp",
	home = os.getenv("HOME"),

	-- display order
	-- modules_order = { "cpu", "temp", "packages", "vol", "backlight", "bat", "weather", "time" },
	modules_order = { "temp", "battery", "volume", "backlight", "weather", "time" },

	-- backlight_cards
	backlight_cards = { "nvidia_0", "amdgpu_bl0", "amdgpu_bl1", "amdgpu_bl2" },

	battery_path = "/sys/class/power_supply/BAT0",
	wttr_path = os.getenv("HOME") .. "/.cache/wttr.status",

	output_mode = "stdout", -- or "xsetroot" / "fifo"
}
