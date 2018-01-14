#arguments.
ZSH_COMMAND_TIME_MIN_SECONDS=5
ZSH_COMMAND_TIME_ECHO=1
eval $(thefuck --alias)

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
alias shell="killall plasmashell && kstart5 plasmashell"
alias plank="killall plank && kstart5 plank && exit"
alias free="free -h"
alias network="sc-restart NetworkManager"
alias blame="systemd-analyze && systemd-analyze blame"
alias neofetch="clear && neofetch"
alias journal="journalctl -b0 -p err"
alias fdisk="sudo fdisk -l"
alias cleanj="sudo journalctl --vacuum-time=5d"
alias css="cd ~viv && sh /run/media/dark-emperor/Dark-Files/Stuff/Others/Scripts/custom.sh"
alias ls="colorls"
alias l="colorls -a"
alias st="$exec /opt/sublime_text_3/sublime_text"
alias tk= "tmux kill-server"
alias zsh="exec zsh"
alias cleanc="octopi-cachecleaner"
alias sysinfo="sh /run/media/dark-emperor/Dark-Files/Stuff/Others/Git/Scripts/sysinfo.sh"
alias pinfo="pacman -Qi "
alias open="xdg-open"

#spotify aliases.
alias spn="sp next"
alias spv="sp prev"
alias spp="sp play"
alias spc="sp current"
alias spf="sp feh"
alias sph="sp help"
alias spm="sp metadata"

# git aliases.
alias gs="git status"
alias ga="git add"
alias gaa="git add -A"

#Directory hashes.
hash -d exercises="/run/media/dark-emperor/Dark-Files/Learning/Bridging/Programmig/exercises"
hash -d disk="/run/media/dark-emperor/Dark-Files"
hash -d viv="/opt/vivaldi-snapshot/resources/vivaldi/style"
hash -d Stuff="/run/media/dark-emperor/Dark-Files/Stuff"
hash -d sd="/run/media/dark-emperor/Dark-Files/SD Card/"
hash -d dots="/home/dark-emperor/.dotfiles"
hash -d git="/run/media/dark-emperor/Dark-Files/Stuff/Others/Git"
