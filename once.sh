#!/usr/bin/env bash

# this script should only be run once during the first setup
##
# Git Config
##

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


##
# Pacman Stuff
##
# add chaotic and herecura repos
echo -e "Setting up Repos Mirrors..."
cat << EOF >> /etc/pacman.conf
[chaotic-aur]
#SigLevel = Never
Include = /etc/pacman.d/chaotic-mirrorlist

[herecura]
# packages built against stable
Server = https://repo.herecura.be/herecura/x86_64
EOF
echo -e "Pacman Repos Configured Successfully."
