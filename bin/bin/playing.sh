#!/bin/bash
P_ICON=""
S_ICON=""
PLAYERS=$(playerctl -l 2> /dev/null)

for player in $PLAYERS; do
    STATUS=$(playerctl -p $player status 2> /dev/null)
    if [ "$STATUS" == "Playing" ]; then
        CURRENT=$player
        echo $CURRENT > /tmp/last-player
        break; #  prioritize playing players
    elif [ "$STATUS" == "Paused" ]; then
        # use the last playing player if its saved
        if [ -f /tmp/last-player ]; then
            CURRENT=$(tail -1 /tmp/last-player)
        else
            # otherwise use the last player in players list
            CURRENT=$player
        fi
    fi
done

# when no player is playing
if [ -z $CURRENT ]; then
    echo "  No player is running"
else
    # get some metadata
    ARTIST=$(playerctl -p $CURRENT metadata artist 2> /dev/null)
    TITLE=$(playerctl -p $CURRENT metadata title 2> /dev/null)
    URL=$(playerctl -p $CURRENT metadata xesam:url 2> /dev/null)
fi

# if artist or song are empty get filename from URL
# if url is empty use the title
if [ "$ARTIST" == "" ] || [ "$TITLE" == "" ] && [ "$URL" != "" ]; then
    METADATA="$(basename $(playerctl -p $CURRENT metadata xesam:url))"
elif [ "$URL" == "" ]; then
    METADATA=$TITLE
else
    METADATA="$ARTIST - $TITLE"
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
