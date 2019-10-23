#!/bin/bash

if pgrep -x "spotifyd" > /dev/null
then
    STATUS=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotifyd /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus'|egrep -A 1 "string"|cut -b 26-|cut -d '"' -f 1)

    ARTIST=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotifyd /org/mpris/MediaPlayer2 \
            org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' \
            string:'Metadata' |\
            awk -F 'string "' '/string|array/ {printf "%s",$2; next}{print ""}' |\
            awk -F '"' '/artist/ {print $2}')

   SONG=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotifyd /org/mpris/MediaPlayer2 \
            org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' \
            string:'Metadata' |\
            awk -F 'string "' '/string|array/ {printf "%s",$2; next}{print ""}' |\
            awk -F '"' '/title/ {print $2}' | sed -e 's/([^()]*)//g' | cut -c 1-20 )

    if [[ $STATUS = "Playing" ]]; then
    echo " $SONG BY $ARTIST"
    else
    echo " $SONG BY $ARTIST"
    fi
    # mute the audio if an ad is playing(too broke for premium now)
    if [[ $ARTIST = "" ]]; then
        $(pamixer --mute)
    else
        $(pamixer --unmute)
    fi

else
    echo " Spotify is not running"
fi
