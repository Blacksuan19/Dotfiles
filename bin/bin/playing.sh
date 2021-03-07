#!/bin/bash
P_ICON=""
S_ICON=""
PLAYERS=$(playerctl -l 2> /dev/null)

# set current player to the one actually playing or paused
for player in $PLAYERS; do
    STATUS=$(playerctl -p $player status 2> /dev/null)
    if [ "$STATUS" == "Playing" ]; then
        CURRENT=$player
        break; #  prioritize playing players
    elif [ "$STATUS" == "Paused" ]; then
        CURRENT=$player
    fi
done
if [ -z $CURRENT ]; then
echo "  No player is running"
fi
METADATA="$(playerctl -p $CURRENT metadata artist) - $(playerctl -p $CURRENT metadata title)"
TRIM=$(echo $METADATA | sed -e 's/([^()]*)//g' | cut -c 1-50)
ARTIST=$(playerctl metadata artist)
FULL_META=$(playerctl metadata)
case $STATUS in
    "Playing")
            echo $P_ICON"  "$TRIM
            ;;
    "Paused")
            echo $S_ICON"  "$TRIM
            ;;
esac

# for pause play functionality
if [ $# -eq 1 ]
  then
    playerctl -p $CURRENT play-pause
fi
