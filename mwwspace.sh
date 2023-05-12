#!/bin/bash

# Get the ID of the currently focused window
window_id=$(xdotool getactivewindow)

# Move the window to the second workspace
wmctrl -i -r "$window_id" -t $1

