# arguments.
ZSH_COMMAND_TIME_MIN_SECONDS=20
ZSH_COMMAND_TIME_ECHO=0
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
alias c="code"
alias zsh="exec zsh"
alias sysinfo="sh ~/.sysinfo.sh"
alias memefetch="sh ~/.memefetch.sh"
alias open="xdg-open"
alias term="konsole &" # needed sometimes.
alias gpp="g++" # typing two plus signs is stupid.
alias cp="pycp" # this one has a pogress bar ma dude.
alias 3.18="git cherry-pick 3.18/kernel.lnx.3.18.r33-rel "
alias electra="git cherry-pick electra/treble "
alias oveno="git cherry-pick oveno/musk "
alias franco="git cherry-pick franco/oreo-mr1-custom "
alias clang="git cherry-pick clang/msm-3.18-oreo "
alias raph="git cherry-pick raph/stable/penkek "
alias genom="git cherry-pick genom/pie-custom "
alias beta="git cherry-pick darky-beta "

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
alias spl="sp lyrics"
alias lyc="python /bin/lyc"

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
hash -d java="/run/media/dark-emperor/Dark-Files/Kulliyya/CSC1103/exercises"

lolcat -a << EOF


                                ███╗   ███╗ █████╗ ███╗   ██╗     ██╗ █████╗ ██████╗  ██████╗ 
                                ████╗ ████║██╔══██╗████╗  ██║     ██║██╔══██╗██╔══██╗██╔═══██╗
                                ██╔████╔██║███████║██╔██╗ ██║     ██║███████║██████╔╝██║   ██║
                                ██║╚██╔╝██║██╔══██║██║╚██╗██║██   ██║██╔══██║██╔══██╗██║   ██║
                                ██║ ╚═╝ ██║██║  ██║██║ ╚████║╚█████╔╝██║  ██║██║  ██║╚██████╔╝
                                ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 
