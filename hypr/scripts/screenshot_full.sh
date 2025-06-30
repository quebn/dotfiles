#!/usr/bin/bash

dir="$HOME/Pictures/screenshots/"
filename="grim-$(date +%s).png"
filepath="$dir/$filename"

grim "$filepath" && notify-send \
    "Screenshot saved" \
    "~/Pictures/screenshots/$filename" \
    -i "$filepath" \
    -a "Grim"\
    --action=default,"Open Image"

ACTION=$(dunstctl action)
echo "$ACTION"
if [[ "$ACTION" = "default" ]]; then
    xdg-open "$filepath"
fi
