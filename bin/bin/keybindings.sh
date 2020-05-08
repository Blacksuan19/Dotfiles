#!/bin/sh
# a simple script to show sxhkd Keybindings in a searchable rofi window
# main inspration https://www.reddit.com/r/bspwm/comments/aejyze/tip_show_sxhkd_keybindings_with_fuzzy_search/

cat ~/.config/sxhkd/sxhkdrc \
| awk '/\w/ && last { print $0,"\t",last} {last=""} /^#/{gsub("#","");last=$0}' \
| column -t -s $'\t' | rofi -dmenu -i -P "Keybindings:" -width 70
