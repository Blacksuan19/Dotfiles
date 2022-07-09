export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"

# PATH changes
export PATH=$HOME/.local/bin:$PATH                      # user binaries
export PATH=$HOME/.yarn/bin:$PATH                       # yarn executables
export PATH=$HOME/.pub-cache/bin:$PATH                  # flutter executables
export PATH=$GEM_HOME/bin:$PATH                         # ruby gems
export PATH=$HOME/.pyenv/bin:$PATH                      # pyenv executables

# fix gpg
export GPG_TTY=$TTY

# determines search program for fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden""'

# autostart a tmux session
export ZSH_TMUX_AUTOSTART=true
