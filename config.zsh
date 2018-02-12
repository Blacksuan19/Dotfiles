#arguments.
ZSH_COMMAND_TIME_MIN_SECONDS=5
ZSH_COMMAND_TIME_ECHO=1
eval $(dircolors -b $HOME/.dircolors) # just for colors in completions.
LS_COLORS=$(ls_colors_generator) # ls icons.


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

# ls functions.
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
alias install="pacaur -S"
alias pfind="pacaur -Ss "
alias update="pacaur -Syu"
alias orphan="sudo pacman -Rns $(pacman -Qtdq)"
alias shell="killall plasmashell && kstart5 plasmashell"
alias latte="killall latte-dock && kstart5 latte-dock"
alias free="free -h"
alias network="sc-restart NetworkManager"
alias blame="systemd-analyze && systemd-analyze blame"
alias neofetch="clear && neofetch"
alias journal="journalctl -b0 -p err"
alias fdisk="sudo fdisk -l"
alias cleanj="sudo journalctl --vacuum-time=5d"
alias css="cd ~viv && sh /run/media/dark-emperor/Dark-Files/Stuff/Others/Scripts/custom.sh"
alias ls="run_ls"
alias dir="run_dir"
alias vdir="run_vdir"
alias st="$exec /opt/sublime_text_3/sublime_text"
alias tk= "tmux kill-server"
alias zsh="exec zsh"
alias cleanc="sudo pacman -Scc"
alias sysinfo="sh /run/media/dark-emperor/Dark-Files/Stuff/Others/Git/Scripts/sysinfo.sh"
alias pinfo="pacman -Qi "
alias open="xdg-open"
alias term="termite &" #nedded sometimes.

#spotify aliases.
alias spn="sp next"
alias spv="sp prev"
alias spp="sp play"
alias spc="sp current"
alias spf="sp feh"
alias sph="sp help"
alias spm="sp metadata"
alias spl="sp lyrics"

#translator aliases.
alias en="trans " # to english
alias enf="en -d -pager more -i" # translate a file to english
alias es="trans -t es" # to spanish.
alias ara="trans -t ar" # to arabic.
alias ts="trans -shell" # intractive ahell.
alias lyct="lyc | en -d -no-auto -pager more" #translate playing aong lyrics to english.

#git aliases.
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
hash -d android="/run/media/dark-emperor/Dark-Files/Stuff/Android-Development"
hash -d config="/run/media/dark-emperor/Dark-Files/Stuff/Others/Config"