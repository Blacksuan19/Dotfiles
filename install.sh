#!/usr/bin/env bash
# go throw all files (will respect the ignore list)
for files in ~/.dotfiles/*; do
  if [ -d ${files} ]; then
    stow -R $(basename $files)
    if $SCRIPT_DEBUG; then echo "$(basename $files) stowed."; fi
  fi
done
