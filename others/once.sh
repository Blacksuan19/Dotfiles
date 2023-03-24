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
    pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
    pacman-key --lsign-key FBA220DFC880C036
    pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

    # update pacman config
	sudo cp pacman.conf /etc/pacman.conf

    # update repos and install yay
    sudo pacman -Syyu --noconfirm yay

    # Install packages
    packages=(git delta stow exa bat tmux ripgrep duf dust nerd-fonts-jetbrains-mono telegram-desktop-userfonts kwin-bismuth-bin fastfetch mailspring microsoft-edge-stable-bin onlyoffice-bin visual-studio-code-bin mpv)
    yay -S --noconfirm $packages
}

fix_brightness
setup_git
setup_pacman

echo -e "Done!"
