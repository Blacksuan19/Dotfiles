#!/usr/bin/env bash

# install required fonts
function install_fonts() {
	target="$HOME/.local/share/fonts"
	mkdir -p $target

	# install SF Pro font
    git clone https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts.git ~/.local/share/fonts/SanFranciscoPro

    # remove git folder (huge)
    rm -rf ~/.local/share/fonts/SanFranciscoPro/.git
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
		"README.md"
		"screens"
		"plasma"
		"others"
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
