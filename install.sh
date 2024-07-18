#!/usr/bin/env bash

# install required fonts
function install_fonts() {
	target="$HOME/.local/share/fonts"
	mkdir -p $target

	# install SF Pro font
    git clone https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts.git ~/.local/share/fonts/SanFranciscoPro

    # remove git folder (huge)
    cd ~/.local/share/fonts/SanFranciscoPro
    rm -rf .git

    # remove all fonts except SF-Pro.ttf
    rm -rf $(find . -name "*" ! -name "SF-Pro.ttf")

    # update font cache
    fc-cache -f -v

    echo "Fonts installed successfully."

    # return to script directory
    cd - > /dev/null
}

# symlink configs
function stow_con() {

    declare -a dirs=($(ls -d */))
    ignore_list=("others/" "plasma/" "screens/")

    # remove ignored directories from list
    for ignore in ${ignore_list[@]}; do
        dirs=(${dirs[@]/$ignore})
    done

    echo "Stowing Directories: ${dirs[@]}"

    for dir in ${dirs[@]}; do
        stow ${dir}
        if $SCRIPT_DEBUG; then echo "${dir} stowed."; fi
    done
}

stow_con
install_fonts
