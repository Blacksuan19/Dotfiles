# arguments.
ZSH_COMMAND_TIME_MIN_SECONDS=5
ZSH_COMMAND_TIME_ECHO=1
eval $(dircolors -b $HOME/.dircolors) # just for colors in completions.



# systemd aliases.
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

# various aliases.
alias shell="killall plasmashell && kstart5 plasmashell"
alias latte="killall latte-dock && kstart5 latte-dock"
alias free="free -h"
alias network="sc-restart NetworkManager"
alias blame="systemd-analyze && systemd-analyze blame"
alias journal="journalctl -b0 -p err"
alias fdisk="sudo fdisk -l"
alias cleanj="sudo journalctl --vacuum-time=5d"
alias st="subl3"
alias zsh="exec zsh"
alias sysinfo="sh /run/media/dark-emperor/Dark-Files/Dev/Gits/Scripts/sysinfo.sh"
alias open="xdg-open"
alias term="termite &" # nedded sometimes.
alias dict="sdcv -c" # for sdcv dictionary
alias gpp="g++" # typing two plus signs is stupid.
alias cp="pycp" # this one has a pogress bar ma dude.
alias 3.18="git cherry-pick 3.18/kernel.lnx.3.18.r33-rel "
alias electra="git cherry-pick electra/oreo "
alias osp="git cherry-pick osp/oreo "
alias thun="git cherry-pick thunder/android-5.1 "

#packages aliases.
alias remove="sudo pacman -Rs"
alias install="pacaur -S"
alias update="pacaur -Syu"
alias pfind="pacaur -Ss " # find a package in the repo's or AUR.
alias pinfo="pacman -Qi " # get info of an installed package.
alias orphan="sudo pacman -Rns $(pacman -Qtdq)" # remove orphaned packages.
alias cleanc="sudo pacman -Scc" # clean cached packages files.

#spotify aliases.
alias spn="sp next"
alias spv="sp prev"
alias spp="sp play"
alias spc="sp current"
alias spf="sp feh"
alias sph="sp help"
alias spm="sp metadata"
alias spl="sp lyrics"
alias lyc="python /bin/lyc"

#translator script aliases.
alias en="trans " # to english
alias enf="en -d -pager more -i" # translate a file to english
alias es="trans -t es" # to spanish.
alias ara="trans -t ar" # to arabic.
alias ts="trans -shell" # intractive shell.
alias lyct="lyc | en -d -no-auto -pager more" # translate playing song lyrics to english.

# git aliases.
alias gs="git status"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit --signoff"

# Directory hashes.
hash -d disk="/run/media/dark-emperor/Dark-Files"
hash -d dev="/run/media/dark-emperor/Dark-Files/Dev"
hash -d sd="/run/media/dark-emperor/Dark-Files/SD Card/"
hash -d dots="/home/dark-emperor/.dotfiles"
hash -d git="/run/media/dark-emperor/Dark-Files/Dev/Gits"
hash -d android="/run/media/dark-emperor/Dark-Files/Dev/Android"
hash -d da="/run/media/dark-emperor/Dark-Files/Dev/Android/Dark-Ages"