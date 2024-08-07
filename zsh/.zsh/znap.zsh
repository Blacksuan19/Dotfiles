# Download Znap, if it's not there yet.
[[ -f ~/.zsh-snap/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.zsh-snap/zsh-snap

source ~/.zsh-snap/zsh-snap/znap.zsh

# prompt
eval "$(starship init zsh)"
znap prompt

# stuff from prezto or oh-my-zsh
znap source sorin-ionescu/prezto modules/{history,completion,editor,directory}
znap source ohmyzsh/ohmyzsh plugins/{sudo,extract,git,tmux,python,pyenv,pip,common-aliases,aliases}

# plugins
znap source Aloxaf/fzf-tab
znap source marlonrichert/zcolors
znap source zsh-users/zsh-autosuggestions
znap source zdharma-continuum/fast-syntax-highlighting
znap source mikcho/zsh-systemd
znap source ael-code/zsh-colored-man-pages

# completion
znap source pyenv/pyenv completions
znap source MenkeTechnologies/zsh-cargo-completion

znap function _pip_completion pip       'eval "$( pip completion --zsh )"'
compctl -K    _pip_completion pip

# aws cli completion
complete -C '/usr/bin/aws_completer' aws
complete -C '/usr/bin/aws_completer' awslocal
