-- cpu blocks
local M = {}

local prev_total, prev_idle

function M.command()
	-- read /proc/stat the first line
	local function read_cpu_stat(path)
		local f = io.open(path, "r")
		if not f then
			return nil
		end
		local line = f:read("*l")
		f:close()
		return line
	end

	local function parse_cpu_stat(line)
		local parts = {}
		for part in line:gmatch("%S+") do
			table.insert(parts, part)
		end

		-- user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice
		-- see: https://man7.org/linux/man-pages/man5/proc.5.html
		local user = tonumber(parts[2]) or 0
		local nice = tonumber(parts[3]) or 0
		local system = tonumber(parts[4]) or 0
		local idle = tonumber(parts[5]) or 0
		local iowait = tonumber(parts[6]) or 0
		local irq = tonumber(parts[7]) or 0
		local softirq = tonumber(parts[8]) or 0
		local steal = tonumber(parts[9]) or 0

		local total = user + nice + system + idle + iowait + irq + softirq + steal
		local idle_time = idle + iowait

		return total, idle_time
	end

	local line = read_cpu_stat("/proc/stat")
	local total, idle = parse_cpu_stat(line)
	if not prev_total then
		prev_total, prev_idle = total, idle
		return " ..." -- 第一次无数据
	end
	local diff_total = total - prev_total
	local diff_idle = idle - prev_idle
	prev_total, prev_idle = total, idle
	if diff_total == 0 then
		return " 0%"
	end
	local usage = (diff_total - diff_idle) / diff_total * 100

	return string.format(" %.0f%%", usage)
end

return M
