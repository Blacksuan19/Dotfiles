# properly setup pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# fix perl language when using package manager
export LC_ALL=en_US.UTF-8

