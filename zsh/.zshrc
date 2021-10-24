# only sourcing here!!
source $HOME/.zprezto/init.zsh
source $HOME/.zsh/fast/fast-syntax-highlighting.plugin.zsh
source $HOME/.zsh/config.zsh
source $HOME/.zsh/functions.zsh

# path changes
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"
export PATH=$HOME/.yarn/bin:$PATH
export GPG_TTY=$TTY # fix gpg

# FZF bindings
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# python virtualenv
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME
source /usr/bin/virtualenvwrapper.sh
