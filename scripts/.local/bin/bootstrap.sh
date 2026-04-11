#!/usr/bin/env bash

# this script should only be run once during the first setup
set -euo pipefail

source_path="${BASH_SOURCE[0]}"
while [[ -L "$source_path" ]]; do
  script_dir="$(cd -P "$(dirname "$source_path")" && pwd)"
  source_path="$(readlink "$source_path")"
  [[ "$source_path" != /* ]] && source_path="$script_dir/$source_path"
done

SCRIPT_DIR="$(cd -P "$(dirname "$source_path")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
PACKAGES_FILE="$REPO_ROOT/tools/bootstrap/packages-arch.txt"

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

    if [[ ! -f "$PACKAGES_FILE" ]]; then
        echo "Package list not found: $PACKAGES_FILE"
        exit 1
    fi

    # Install packages from a separate list file for easy maintenance.
    mapfile -t packages < <(grep -Ev '^\s*#|^\s*$' "$PACKAGES_FILE")
    if (( ${#packages[@]} == 0 )); then
        echo "No packages found in $PACKAGES_FILE"
        exit 1
    fi

    yay -S --noconfirm "${packages[@]}"
}

setup_git
setup_pacman

echo -e "Done!"
