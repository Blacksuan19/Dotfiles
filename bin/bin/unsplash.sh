#/bin/bash

# get a random 1080p wallpaper from unsplash.com whenever this script is run
# depends on notify-send for notifications, imagemagick for blur effect
# run hourly with cron:
# @hourly $HOME/bin/unsplash.sh

notify-send "Getting new wallpaper..."
wget -O $HOME/.wallpaper.jpg "https://source.unsplash.com/random/1920x1080/?wallpaper" &> /dev/null

# apply some light blur first
# convert $HOME/.wallpaper.jpg -filter Gaussian -blur 0x2 $HOME/.blur-wall.jpg

# set bg via feh so we can restore it on boot
feh --bg-fill $HOME/.wallpaper.jpg

# update betterlockscreen wallpaper
betterlockscreen -u $HOME/.wallpaper.jpg dimblur &> /dev/null

#we out
notify-send "New wallpaper set successfully."
