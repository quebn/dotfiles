import "root:/"
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton
pragma ComponentBehavior: Bound

/**
 * A nice wrapper for date and time strings.
 * Qt.formatDateTime(clock.date, "HH:mm • dddd, MM/dd ")
 */
Singleton {
    property string time: Qt.locale().toString(clock.date, "HH:mm")
    property string date: Qt.locale().toString(clock.date, "dddd, MM/dd")
    property string collapsedCalendarFormat: Qt.locale().toString(clock.date, "dd MMMM yyyy")
    property string uptime: "0h, 0m"

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: {
            fileUptime.reload()
            const textUptime = fileUptime.text()
            const uptimeSeconds = Number(textUptime.split(" ")[0] ?? 0)

            // Convert seconds to days, hours, and minutes
            const days = Math.floor(uptimeSeconds / 86400)
            const hours = Math.floor((uptimeSeconds % 86400) / 3600)
            const minutes = Math.floor((uptimeSeconds % 3600) / 60)

            // Build the formatted uptime string
            let formatted = ""
            if (days > 0) formatted += `${days}d`
            if (hours > 0) formatted += `${formatted ? ", " : ""}${hours}h`
            if (minutes > 0 || !formatted) formatted += `${formatted ? ", " : ""}${minutes}m`
            uptime = formatted
            interval = 60000
        }
    }

    FileView {
        id: fileUptime

        path: "/proc/uptime"
    }

}
