#!/bin/bash
drive=~/Drive/notes/
compare_remote(){
    flag=flase
    for((i=0;i< remlen ;i++));
    do
        for((j=0;j<loclen;j++));
        do
            if [ -n "${remote5[$i]}==${local5[$j]}" ]; then
                notify-send -u normal -t 5000 "Notes" "No remote changes detected"
            else
                notify-send -u normal -t 5000 "Notes" "shits new ma dude"
                # flag=true
            fi
        done
        
    done

    if [ "$flag" == true ]; then
        notify-send -u normal -t 5000 "Notes" "New Changes Detected, Pulling..."
        drive pull -no-prompt -ignore-conflict ~/Drive/notes
    fi
}

remote5=($(drive md5sum notes | awk '{print $1}'))
local5=($(md5sum notes/* | awk '{print $1}'))
remlen=${#remote5[@]}
loclen=${#local5[@]}
inotifywait -m $drive -e create -e delete -e modify | while read -r event; do
    notify-send -u normal -t 5000 "Notes" "Syncing Files..."
    drive push -no-prompt ~/Drive/notes/
    notify-send -u normal -t 5000 "Notes" "Synced Successfully!"
    
done

