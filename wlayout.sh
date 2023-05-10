#!/bin/bash

# Get the active workspace
workspace=$(xdotool get_desktop)

# Get the list of windows in the active workspace
windows=$(xdotool search --onlyvisible --desktop $workspace '' 2>/dev/null)

# Get the screen size
screen_width=$(xdotool getdisplaygeometry | awk '{print $1}')
screen_height=$(xdotool getdisplaygeometry | awk '{print $2}')

# the panel
panel=30

# Calculate the usable screen size
usable_width=$screen_width
usable_height=$(($screen_height - $panel))

# Determine the number of windows found
num_windows=$(echo "$windows" | wc -l)

# Determine the layout based on the number of windows
case $num_windows in
    1)
        # If there is only one window, put it in the center of the screen
        xdotool windowsize $(echo $windows | cut -d' ' -f1) $usable_width $usable_height
        xdotool windowmove $(echo $windows | cut -d' ' -f1) $((($screen_width - $usable_width) / 2)) $((($screen_height - $usable_height) / 2))
        ;;
    2)
        # If there are two windows, put them side by side
        width=$(($usable_width / 2))
        height=$usable_height
        xdotool windowsize $(echo $windows | cut -d' ' -f1) $width $height
        xdotool windowmove $(echo $windows | cut -d' ' -f1) 0 0
        xdotool windowsize $(echo $windows | cut -d' ' -f2) $width $height
        xdotool windowmove $(echo $windows | cut -d' ' -f2) $width 0
        ;;
    3)
        # If there are three windows, put two windows side by side and the third window below the first window
        width=$(($usable_width / 2))
        height=$(($usable_height / 2))
        xdotool windowsize $(echo $windows | cut -d' ' -f1) $width $height
        xdotool windowmove $(echo $windows | cut -d' ' -f1) 0 0
        xdotool windowsize $(echo $windows | cut -d' ' -f2) $width $height
        xdotool windowmove $(echo $windows | cut -d' ' -f2) $width 0
        xdotool windowsize $(echo $windows | cut -d' ' -f3) $usable_width $height
        xdotool windowmove $(echo $windows | cut -d' ' -f3) 0 $height
        ;;
    *)
        # If there are four or more windows, put them in a 2x2 grid
		width=$(($usable_width / 2))
		height=$(($usable_height / 2))
		xdotool windowsize $(echo $windows | cut -d' ' -f1) $width $height
        xdotool windowmove $(echo $windows | cut -d' ' -f1) 0 0

        xdotool windowsize $(echo $windows | cut -d' ' -f2) $width $height
        xdotool windowmove $(echo $windows | cut -d' ' -f2) $width 0

        xdotool windowsize $(echo $windows | cut -d' ' -f3) $width $height
		xdotool windowmove $(echo $windows | cut -d' ' -f3) 0 $height

        xdotool windowmove $(echo $windows | cut -d' ' -f4) $width $height
		xdotool windowsize $(echo $windows | cut -d' ' -f4) $width $height
		;;
esac

