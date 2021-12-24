#!/usr/bin/env bash

# this script should only be run once during the first setup

##
# Pacman Stuff
##
# add chaotic and herecura repos
function setup_repos() {
sudo cp pacman.conf /etc/pacman.conf
}

##
# Git Config
##
function setup_git() {
echo -e "Configuring git..."
# setup user details
git config --global user.name Blacksuan19
git config --global user.email abubakaryagob@gmail.com

# setup gpg signing
git config --global --add gpg.program /usr/bin/gpg
git config --global commit.gpgsign true

# setup diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global interactive.diffFilter "diff-so-fancy --patch"
git config --global color.ui true

git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"

git config --global color.diff.meta       "11"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.func       "146 bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverseenv bash"
echo -e "Git Configured Successfully."
}

setup_repos
# install yay from chaotic-aur
sudo pacman -S --noconfirm yay

##
# Install packages
##
packages=(git diff-so-fancy stow lsd bat ksuperkey tmux ripgrep duf dust nerd-fonts-jetbrains-mono notion-app-enhanced picom-jonaburg-git)
yay -S --noconfirm $packages

setup_git
# setup prezto
echo -e "Downloading prezto..."
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" &> /dev/null
