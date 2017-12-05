#systemd aliases.
 user_commands=(
  list-units is-active status show help list-unit-files
  is-enabled list-jobs show-environment cat list-timers)

sudo_commands=(
  start stop reload restart try-restart isolate kill
  reset-failed enable disable reenable preset mask unmask
  link load cancel set-environment unset-environment
  edit)

for c in $user_commands; do; alias sc-$c="systemctl $c"; done
for c in $sudo_commands; do; alias sc-$c="sudo systemctl $c"; done

alias sc-enable-now="sc-enable --now"
alias sc-disable-now="sc-disable --now"
alias sc-mask-now="sc-mask --now"

#Directory colors.
LS_COLORS=$(ls_colors_generator)
run_ls() {
    ls-i --color=auto -w $(tput cols) "$@"
}

run_dir() {
    dir-i --color=auto -w $(tput cols) "$@"
}

run_vdir() {
    vdir-i --color=auto -w $(tput cols) "$@"
}
# double press Esc to add sudo.
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == $EDITOR\ * ]]; then
        LBUFFER="${LBUFFER#$EDITOR }"
        LBUFFER="sudoedit $LBUFFER"
    elif [[ $BUFFER == sudoedit\ * ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="$EDITOR $LBUFFER"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line
#aliases.
alias remove="sudo pacman -Rs"
alias install="packer -S"
alias update="packer -Syu"
alias shell="killall plasmashell && kstart plasmashell"
alias plank="killall plank && kstart plank"
alias orphan="sudo pacman -Rns $(pacman -Qtdq) && sudo pacman -Rns $(pacman -Qttdq)"
alias free="free -h"
alias setoolkit="sudo setoolkit"
alias network="sc-restart NetworkManager"
alias blame="systemd-analyze && systemd-analyze blame"
alias boot="journalctl -p err -b"
alias neofetch="clear && neofetch"
alias journal="journalctl -b0 -p err"
alias fdisk="sudo fdisk -l"
alias cleanj="sudo journalctl --vacuum-time=5d"
alias inxi="sudo inxi -Fm"
alias css="cd ~viv && sh /run/media/dark-emperor/Dark-Files/stuff/Others/custom.sh"
alias ls="run_ls"
alias dir="run_dir"
alias vdir="run_vdir"
alias st="/opt/sublime_text_3/sublime"
alias tk= "tmux kill-server"
alias zsh="exec zsh"

#Directory hashes.
hash -d exercises="/run/media/dark-emperor/Dark-Files/Learning/Bridging/Programmig/exercises"
hash -d disk="/run/media/dark-emperor/Dark-Files"
hash -d viv="/opt/vivaldi-snapshot/resources/vivaldi/style"
hash -d stuff="/run/media/dark-emperor/Dark-Files/stuff"
hash -d sd="/run/media/dark-emperor/Dark-Files/SD Card/"
hash -d dots="/home/dark-emperor/.dotfiles"

