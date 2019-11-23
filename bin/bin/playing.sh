#!/bin/sh

if pgrep -x "spotify" > /dev/null || pgrep -x "cmus" > /dev/null
then
    PID=$(pgrep -x "cmus" || pgrep -x "spotify" | head -1)
    PLAYER=$(ps -p $PID -o comm=)
    STATUS=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$PLAYER /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus'|egrep -A 1 "string"|cut -b 26-|cut -d '"' -f 1)

    ARTIST=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$PLAYER /org/mpris/MediaPlayer2 \
        org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' \
        string:'Metadata' |\
        awk -F 'string "' '/string|array/ {printf "%s",$2; next}{print ""}' |\
        awk -F '"' '/artist/ {print $2}')

    SONG=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.$PLAYER /org/mpris/MediaPlayer2 \
        org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' \
        string:'Metadata' |\
        awk -F 'string "' '/string|array/ {printf "%s",$2; next}{print ""}' |\
        awk -F '"' '/title/ {print $2}' | sed -e 's/([^()]*)//g' | cut -c 1-20 )

    if [ $STATUS = "Playing" ]; then
    echo " $SONG - $ARTIST"
    else
    echo " $SONG - $ARTIST"
    fi
    else
        echo " No player is running"
    fi
