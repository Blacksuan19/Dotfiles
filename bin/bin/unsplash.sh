#/bin/bash

# get a random 1080p wallpaper from unsplash.com whenever this script is run
# depends on notify-send for notifications, imagemagick for blur effect
# run hourly with cron:
# @hourly $HOME/bin/unsplash.sh

notify-send "Getting new wallpaper..."
wget -O /tmp/wallpaper.jpg "https://source.unsplash.com/random/1920x1080/?wallpaper" &> /dev/null
# apply some light blur first
convert /tmp/wallpaper.jpg -filter Gaussian -blur 0x2 /tmp/blur-wall.jpg
feh --bg-fill /tmp/blur-wall.jpg
notify-send "New wallpaper set successfully."
