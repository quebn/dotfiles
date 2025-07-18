pragma Singleton
pragma ComponentBehavior: Bound

import qs
import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Simple polled resource usage service with RAM, Swap, and CPU usage.
 */
Singleton {
	property double memoryTotal: 1
	property double memoryFree: 1
	property double memoryUsed: memoryTotal - memoryFree
    property double memoryUsedPercentage: memoryUsed / memoryTotal
    property double swapTotal: 1
	property double swapFree: 1
	property double swapUsed: swapTotal - swapFree
    property double swapUsedPercentage: swapTotal > 0 ? (swapUsed / swapTotal) : 0
    property double cpuUsage: 0
    property var prevCpuStats

	Timer {
		interval: 1
        running: true
        repeat: true
		onTriggered: {
            // Reload files
            fileMeminfo.reload()
            fileStat.reload()

            // Parse memory and swap usage
            const textMemInfo = fileMeminfo.text()
            memoryTotal = Number(textMemInfo.match(/MemTotal: *(\d+)/)?.[1] ?? 1)
            memoryFree = Number(textMemInfo.match(/MemAvailable: *(\d+)/)?.[1] ?? 0)
            swapTotal = Number(textMemInfo.match(/SwapTotal: *(\d+)/)?.[1] ?? 1)
            swapFree = Number(textMemInfo.match(/SwapFree: *(\d+)/)?.[1] ?? 0)

            // Parse CPU usage
            // TODO: make average cpu usage.
            const textStat = fileStat.text()
            const cpuLine = textStat.match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/)
            if (cpuLine) {
                const stats = cpuLine.slice(1).map(Number)
                const total = stats.reduce((a, b) => a + b, 0)
                const idle = stats[3]

                if (prevCpuStats) {
                    const totalDiff = total - prevCpuStats.total
                    const idleDiff = idle - prevCpuStats.idle
                    cpuUsage = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0
                }

                prevCpuStats = { total, idle }
            }
            interval = 10000 // 10 secs
        }
	}

	FileView { id: fileMeminfo; path: "/proc/meminfo" }
    FileView { id: fileStat; path: "/proc/stat" }
}
