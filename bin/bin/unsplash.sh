#/bin/bash
# copyright © blacksuan19 @ 2020
# get a random 1080p wallpaper from unsplash.com whenever this script is run
# depends on notify-send for notifications, feh for setting wallpaper
# run hourly with cron:
# @hourly $HOME/bin/unsplash.sh

notify-send "Getting new wallpaper..."
wget --no-check-certificate -O $HOME/.wallpaper "https://source.unsplash.com/random/1920x1080/?wallpaper" &> /dev/null

# set desktop wallpaper
feh --bg-fill $HOME/.wallpaper

# update simplelock wallpaper (change to whatever lockscreen you use)
simplelock -w

# we out
notify-send "New wallpaper set successfully."
