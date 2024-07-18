#!/usr/bin/env bash

# this script should only be run once during the first setup

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

# Pacman Stuff
function setup_pacman() {
    # setup chaotic AUR
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

    # update pacman config
    sudo tee -a /etc/pacman.conf > /dev/null <<EOT

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOT

    # update repos and install yay
    sudo pacman -Syyu --noconfirm yay

    # Install packages
    packages=(git git-delta stow exa bat tmux ripgrep duf dust ttf-jetbrains-mono-nerd fastfetch mailspring microsoft-edge-stable-bin onlyoffice-bin visual-studio-code-bin)
    yay -S --noconfirm $packages
}

setup_git
setup_pacman

echo -e "Done!"
