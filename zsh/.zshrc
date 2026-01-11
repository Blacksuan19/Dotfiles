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

# zoxide setup
eval "$(zoxide init zsh)"

# setup rbenv
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init - zsh)"
fi

# setup vscode zsh integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"


# hide gtk window controls
gsettings set org.gnome.desktop.wm.preferences button-layout ':'

