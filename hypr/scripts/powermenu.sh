#!/usr/bin/env bash

dir="$HOME/.config/rofi"
theme="powermenu"

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"
host=`hostname`

# Options
shutdown=""
reboot=""
logout=""
yes=""
no=""

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "Uptime: $uptime" \
		-mesg "Uptime: $uptime" \
		-theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg "Confirm $1?" \
		-theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd $1
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$shutdown\n$reboot\n$logout" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit $1)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == 'Shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == 'Reboot' ]]; then
			systemctl reboot
		elif [[ $1 == 'Logout' ]]; then
			uwsm stop
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd Shutdown
        ;;
    $reboot)
		run_cmd Reboot
        ;;
    $logout)
		run_cmd Logout
        ;;
esac
