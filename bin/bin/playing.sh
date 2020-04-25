#!/bin/sh

STATUS=$(playerctl status 2> /dev/null)

#TODO find a better way to handle not running case
if [ "$STATUS" != "Playing" ] && [ "$STATUS" != "Paused" ]; then
    echo " No player is running"
else
    P_ICON=""
    S_ICON=""
    METADATA="$(playerctl metadata artist) - $(playerctl metadata title)"
    TRIM=$(echo $METADATA | sed -e 's/([^()]*)//g' | cut -c 1-50) 
    case $STATUS in
        "Playing")
            echo $P_ICON $TRIM;;
        "Paused")
            echo $S_ICON $TRIM;;
    esac
fi
