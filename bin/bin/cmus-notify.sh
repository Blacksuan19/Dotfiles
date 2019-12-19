#!/usr/bin/env sh

cmus_notify --title "$(printf "{status}: {title} \nBY {artist}")" --body "$(printf "<b>Album:</b> {album}\n<b>Duration:</b> {duration}")" "$*"
