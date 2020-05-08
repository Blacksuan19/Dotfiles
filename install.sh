#!/usr/bin/env bash

# ignored files list
declare -a ignore_list=(".git"
                        ".gitignore"
                        ".gitmodules"
                        "README.md"
                        "screen1.png"
                        "screen2.png"
                        "screen3.png"
                        "screen4.png"
                    )

# go throw all files except ignore list
for file in ~/.dotfiles/*; do
  if [ -d ${file} ] && [[ ! ${file} =~ ${ignore_list[@]} ]]; then
    stow $(basename $file)
    if $SCRIPT_DEBUG; then echo "$(basename $file) stowed."; fi
  fi
done
