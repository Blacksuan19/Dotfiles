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
alias ipm="/usr/lib/inkdrop/resources/app/ipm/bin/ipm"
alias free="free -h"
alias network="sc-restart NetworkManager"
alias blame="systemd-analyze && systemd-analyze blame"
alias journal="journalctl -b0 -p err"
alias fdisk="sudo fdisk -l"
alias cleanj="sudo journalctl --vacuum-time=5d"
alias cpr="rsync --progress --size-only --inplace --verbose "
alias c="code --disable-gpu"
alias v="nvim"
alias cat="bat " # this one is way better
alias ls="lsd"
alias l="lsd -al"
alias zsh="exec zsh"
alias sysinfo="sh ~/.sysinfo.sh"
alias open="xdg-open"
alias poly="killall polybar && polybar main </dev/null &>/dev/null &"
alias gpp="g++" # typing two plus signs is stupid.
alias 3.18="git cherry-pick 3.18/kernel.lnx.3.18.r33-rel "

#packages aliases.
alias y="yay"
alias remove="yay -Rs"
alias install="yay -S"
alias pinfo="yay -Qi " # get info of an installed package.
alias orphan="yay -Rns $(pacman -Qtdq)" # remove orphaned packages.
alias cleanc="yay -Scc" # clean cached packages files.

#spotify aliases.
alias spn="sp next"
alias spv="sp prev"
alias spp="sp play"
alias spc="sp current"
alias spf="sp feh"
alias sph="sp help"
alias spm="sp metadata"
alias spl="sp lyrics | bat" # prettier
alias lyc="python /bin/lyc"

# git aliases.
alias gs="git status"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit --signoff"
alias gcp="git cherry-pick"
alias gl="git log | bat"

# Directory hashes.
hash -d disk="/run/media/Dark-Files"
hash -d idea="/run/media/Dark-Files/IdeaProjects"
hash -d sd="/run/media/Dark-Files/SD Card/"
hash -d dots="/home/blacksuan19/.dotfiles"
hash -d git="/run/media/Dark-Files/Gits"
hash -d android="/run/media/Dark-Files/Android-DEV"
hash -d da="/run/media/Dark-Files/Android-DEV/Dark-Ages"
hash -d trees="/run/media/Dark-Files/Android-DEV/Trees"
hash -d flutter="/run/media/Dark-Files/Flutter"
hash -d fox="/home/blacksuan19/.mozilla/firefox/5z0wud4p.dev-edition-default-1567701945705/chrome"