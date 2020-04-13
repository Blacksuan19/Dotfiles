# ls colors
eval $( dircolors -b $HOME/.dircolors )

# default editor
export EDITOR=nvim

# determines search program for fzf
if type rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden""'
fi

# various aliases.
alias free="free -h"
alias fdisk="sudo fdisk -l"
alias c="bat " # this one is way better
alias zsh="exec zsh"
alias n="nvim"
alias py="python3"
alias vifm="vifmrun"

# packages aliases.
alias y="yay"
alias remove="yay -Rds"
alias install="yay -S"
alias pinfo="yay -Qi " # get info of an installed package.
alias orphan="yay -Rns $(pacman -Qtdq)" # remove orphaned packages.
alias cleanc="yay -Scc" # clean cached packages files.

# git aliases.
alias gs="git status"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit --signoff"
alias gcp="git cherry-pick"
alias gl="git log | bat"
alias gr="git remote"
alias gra="git remote add"
alias grm="git remote rm"
alias grv="git remote -v"
alias gd="git diff"
alias gpl="git pull"
alias gclean="git reflog expire --all --expire=now && git gc --prune=now --aggressive"

# Directory hashes.
hash -d disk="/media/Dark-Files"
hash -d dots="/home/blacksuan19/.dotfiles"
hash -d git="/media/Dark-Files/Gits"
hash -d dav="/media/Dark-Files/Android-DEV/kernel/vince"
hash -d dax="/media/Dark-Files/Android-DEV/kernel/phoenix"
hash -d trees="/media/Dark-Files/Android-DEV/Trees"
hash -d vince="/media/Dark-Files/Android-DEV/Trees/vince"
hash -d ph="/media/Dark-Files/Android-DEV/Trees/phoneix"
hash -d flutter="/media/Dark-Files/Flutter"
hash -d kul="/media/Dark-Files/Kulliyya"
