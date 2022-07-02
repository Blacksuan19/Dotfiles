# saucing
source ~/.zsh/exports.zsh
source ~/.zsh/znap.zsh
source ~/.zsh/config.zsh
source ~/.zsh/aliases.zsh

# safe options for cp, rm, mv
zstyle ':prezto:module:utility' safe-ops 'yes'

# fix fzf-tab formatting
zstyle -d ':completion:*' format
zstyle ':completion:*:descriptions' format '[%d]'

# FZF bindings
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
