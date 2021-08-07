#!/usr/bin/env bash

# install required fonts
function install_fonts() {
    target="$HOME/.local/share/fonts"
    mkdir -p $target

    # install apple SanFranciscoDisplay font
    curl https://codeload.github.com/AppleDesignResources/SanFranciscoFont/zip/master \
       --output SF.zip
    unzip -j SF.zip SanFranciscoFont-master/SanFranciscoDisplay-\* -d $target/SanFranciscoDisplay

    # cleanup
    rm SF.zip
}

# clone install plasma theme
function install_themes() {
    git clone https://github.com/material-ocean/Plasma-Theme /tmp/plasma-theme
    cd /tmp/plasma-theme
    bash install.sh
    cd -
    rm -rf /tmp/plasma-theme
}
# symlink configs
function stow_con() {
    # ignored files list
    declare -a ignore_list=(".git"
                            ".gitignore"
                            ".gitmodules"
                            "once.sh"
                            "README.md"
                            "screens"
                        )

    # go throw all files except ignore list
    for file in ~/.dotfiles/*; do
      if [ -d ${file} ] && [[ ! ${file} =~ ${ignore_list[@]} ]]; then
        stow $(basename $file)
        if $SCRIPT_DEBUG; then echo "$(basename $file) stowed."; fi
      fi
    done
}

stow_con
install_fonts
install_themes
