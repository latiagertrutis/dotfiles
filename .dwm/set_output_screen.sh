#!/bin/bash

output_screen="$1"

for screen in $(xrandr | grep " connected" | awk '{ print$1 }'); do
    xrandr --output "$screen" --off
done;

xrandr --output $output_screen --auto
