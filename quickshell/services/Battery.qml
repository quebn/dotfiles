pragma Singleton

import qs
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.UPower

Singleton {
    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge
    property real percentage: UPower.displayDevice.percentage
    readonly property bool allowAutomaticSuspend: Config.options.battery.automaticSuspend
    readonly property string nerdSymbol: isPluggedIn ? "󰚥" :
    (percentage * 100 > 60) ? "󱊣" :
    (percentage * 100 > 30) ? "󱊢" : "󱊡"

    property bool isLow: percentage <= Config.options.battery.low / 100
    property bool isCritical: percentage <= Config.options.battery.critical / 100
    property bool isSuspending: percentage <= Config.options.battery.suspend / 100

    property bool isLowAndNotCharging: isLow && !isCharging
    property bool isCriticalAndNotCharging: isCritical && !isCharging
    property bool isSuspendingAndNotCharging: allowAutomaticSuspend && isSuspending && !isCharging
}
