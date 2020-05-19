# shell settings
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.

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
