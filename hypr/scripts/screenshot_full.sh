#!/usr/bin/bash

dir="$HOME/Pictures/screenshots/"
filename="screenshot-$(date +%s).png"
filepath="$dir/$filename"

action="$(grim "$filepath" && notify-send \
    "Screenshot saved" \
    "~/Pictures/screenshots/$filename" \
    -i "$filepath" \
    -a "Grim"\
    --action=open="Open Image")"

if [[ "$action" == "open" ]]; then
    satty --filename $filepath
fi
