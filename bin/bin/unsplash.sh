#/bin/bash
# copyright © blacksuan19 @ 2020
# get a random 1080p wallpaper from unsplash.com whenever this script is run
# depends on notify-send for notifications, betterlockscreen for setting desktop and
# lockscreen wallpapers
# run hourly with cron:
# @hourly $HOME/bin/unsplash.sh

notify-send "Getting new wallpaper..."
wget --no-check-certificate -O $HOME/.wallpaper "https://source.unsplash.com/random/1920x1080/?wallpaper" &> /dev/null

# update betterlockscreen wallpaper
betterlockscreen -u $HOME/.wallpaper blur &> /dev/null

# set desktop wallpaper(add `blur` to use the blurred version)
betterlockscreen -w

#we out
notify-send "New wallpaper set successfully."
