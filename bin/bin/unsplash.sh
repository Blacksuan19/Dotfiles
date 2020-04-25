#/bin/bash

# get a random 1080p wallpaper from unsplash.com whenever this script is run
# depends on notify-send for notifications
# run hourly with cron:
# @hourly $HOME/bin/unsplash.sh

notify-send "Getting new wallpaper..."
wget -O /tmp/wallpaper.jpg https://unsplash.it/1920/1080/?random &> /dev/null
feh --bg-fill /tmp/wallpaper.jpg
notify-send "New wallpaper set successfully."
