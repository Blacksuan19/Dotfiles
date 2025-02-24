#!/bin/bash
cd $(gem env gemdir)/gems/fusuma-$(gem search -e fusuma | grep -oP '\(\K[^\)]+')

./exe/fusuma &

notify-send "Auto start" "Fusuma started!" -i touchpad -a Fusuma
