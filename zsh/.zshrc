# only sourcing here!!
source $HOME/.zprezto/init.zsh
source $HOME/.zsh/fast/fast-syntax-highlighting.plugin.zsh
source $HOME/.zsh/config.zsh
source $HOME/.zsh/functions.zsh
source $HOME/.zsh/systemd.plugin.zsh
source $HOME/.zsh/wakatime.plugin.zsh

# path changes
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"
export PATH=$HOME/.yarn/bin:$PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"

# fix gpg
export GPG_TTY=$TTY

# FZF bindings
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# python version manager
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
