#!/usr/bin/bash

dir=$HOME/Pictures/screenshots/
filefmt=$dir/$(date +%s)_grim.png

grim "$filefmt" && notify-send "Screenshot saved" -i "$filefmt"
