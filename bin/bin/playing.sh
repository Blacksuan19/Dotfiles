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

# when no player is playing
if [ -z $CURRENT ]; then
    echo "  No player is running"
else
    # get artist and song
    ARTIST=$(playerctl -p $CURRENT metadata artist 2> /dev/null)
    SONG=$(playerctl -p $CURRENT metadata title 2> /dev/null)
fi

# if artist or song are empty get filename from URL
if [ "$ARTIST" == "" ] || [ "$SONG" == "" ]; then
    METADATA="$(basename $(playerctl -p $CURRENT metadata xesam:url))"
else
    METADATA="$ARTIST - $SONG"
fi

# remove everything in brackets and cut to 50 characters
TRIM=$(echo $METADATA | sed -e 's/([^()]*)//g' -e 's/%20/ /g' | cut -c 1-50)

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
