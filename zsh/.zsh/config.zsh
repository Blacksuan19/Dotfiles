# enable vi mode
bindkey -v

# ls colors
eval $( dircolors -b $HOME/.dircolors )

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
export EDITOR=nvim

# determines search program for fzf
if type ag &> /dev/null; then
    export FZF_DEFAULT_COMMAND='ag --hidden -p ~/.fignore -g ""'
fi
# various aliases.
alias free="free -h"
alias fdisk="sudo fdisk -l"
alias cpr="rsync --progress --size-only --inplace --verbose "
alias cat="bat " # this one is way better
alias zsh="exec zsh"
alias open="xdg-open 2>/dev/null"
alias poly="killall polybar && polybar main </dev/null &>/dev/null &"
alias gpp="g++" # typing two plus signs is stupid.
alias n="nvim"

# packages aliases.
alias install="baph -i "
alias remove="sudo pacman -Rds "
alias update="baph -u"
alias orphan="sudo pacman -Rns $(pacman -Qtdq)"
alias pinfo="sudo pacman -Qi " # get extensive info about packages

# git aliases.
alias gs="git status"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit --signoff"
alias gcp="git cherry-pick"
alias gl="git log | bat"

# Directory hashes.
hash -d disk="/media/Dark-Files"
hash -d idea="/media/Dark-Files/IdeaProjects"
hash -d sd="/media/Dark-Files/SD Card/"
hash -d dots="/home/blacksuan19/.dotfiles"
hash -d git="/media/Dark-Files/Gits"
hash -d android="/media/Dark-Files/Android-DEV"
hash -d da="/media/Dark-Files/Android-DEV/Dark-Ages"
hash -d trees="/media/Dark-Files/Android-DEV/Trees"
hash -d flutter="/media/Dark-Files/Flutter"
hash -d kul="/media/Dark-Files/Kulliyya"

ufetch # some fancy shit in the begining
