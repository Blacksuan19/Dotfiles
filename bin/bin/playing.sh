#!/bin/sh

STATUS=$(playerctl status 2> /dev/null)

if [ "$STATUS" = "Playing" ]; then
    echo "  $(playerctl metadata artist) - $(playerctl metadata title)"
elif [ "$STATUS" = "Paused" ]; then
    echo "  $(playerctl metadata artist) - $(playerctl metadata title)"
else
    echo " No player is running"
fi
