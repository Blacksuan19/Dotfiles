#!/usr/bin/env bash

# this script should only be run once during the first setup

function fix_brightness() {
	target="/usr/share/X11/xorg.conf.d/10-quirks.conf"

	sudo tee -a $target >/dev/null <<EOT
# Fix brightness randomly changing
Section "InputClass"
        Identifier "Spooky Ghosts"
        MatchProduct "Video Bus"
        Option "Ignore" "on"
EndSection
EOT
}

# Pacman Stuff
function setup_repos() {
	sudo cp pacman.conf /etc/pacman.conf
}

# Git Config
function setup_git() {
	echo -e "Configuring git..."
	echo -n "Git username: "
	read username
	echo -n "Git email address: "
	read email

	# setup user details
	git config --global user.name $username
	git config --global user.email $email

	# setup gpg signing
	git config --global --add gpg.program /usr/bin/gpg
	git config --global commit.gpgsign true
	# setup delta
	git config --global core.pager "delta"
	git config --global interactive.diffFilter "delta --color-only"
	git config --global add.interactive.useBuiltin false
	git config --global delta.navigate true
	git config --global delta.light false
	git config --global merge.conflictstyle "diff3"
	git config --global diff.colorMoved "default"
	echo -e "Git Configured Successfully."
}

setup_repos
# install yay from chaotic-aur
sudo pacman -S --noconfirm yay

# Install packages
packages=(git delta stow lsd bat ksuperkey tmux ripgrep duf dust nerd-fonts-jetbrains-mono ferdium-bin telegram-desktop kwin-bismuth-bin)
yay -S --noconfirm $packages

setup_git

# fix brightness
fix_brightness
