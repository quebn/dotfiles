pragma Singleton
pragma ComponentBehavior: Bound

import "root:/"
import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Simple polled resource usage service with RAM, Swap, and CPU usage.
 */
Singleton {
	property double memory_total: 1
	property double memory_free: 1
	property double memory_used: memory_total - memory_free
    property double memory_used_percentage: memory_used / memory_total
    property double swap_total: 1
	property double swap_free: 1
	property double swap_used: swap_total - swap_free
    property double swap_used_percentage: swap_total > 0 ? (swap_used / swap_total) : 0
    property double cpu_usage: 0
    property var prev_cpu_stats

	Timer {
		interval: 1
        running: true
        repeat: true
		onTriggered: {
            // Reload files
            fileMeminfo.reload()
            fileStat.reload()

            // Parse memory and swap usage
            const text_mem_info = fileMeminfo.text()
            memory_total = Number(text_mem_info.match(/MemTotal: *(\d+)/)?.[1] ?? 1)
            memory_free = Number(text_mem_info.match(/MemAvailable: *(\d+)/)?.[1] ?? 0)
            swap_total = Number(text_mem_info.match(/SwapTotal: *(\d+)/)?.[1] ?? 1)
            swap_free = Number(text_mem_info.match(/SwapFree: *(\d+)/)?.[1] ?? 0)

            // Parse CPU usage
            // TODO: make average cpu usage.
            const text_stat = fileStat.text()
            const cpu_line = text_stat.match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/)
            if (cpu_line) {
                const stats = cpu_line.slice(1).map(Number)
                const total = stats.reduce((a, b) => a + b, 0)
                const idle = stats[3]

                if (prev_cpu_stats) {
                    const totalDiff = total - prev_cpu_stats.total
                    const idleDiff = idle - prev_cpu_stats.idle
                    cpu_usage = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0
                }

                prev_cpu_stats = { total, idle }
            }
            interval = 10000 // 10 secs
        }
	}

	FileView { id: fileMeminfo; path: "/proc/meminfo" }
    FileView { id: fileStat; path: "/proc/stat" }
}
