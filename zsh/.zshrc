# only sourcing here!!
source $HOME/.zprezto/init.zsh
export PATH=$HOME/bin:$PATH
export PATH=${PATH}:$HOME/.gem/ruby/2.7.0/bin:$PATH
source $HOME/.zsh/fast/fast-syntax-highlighting.plugin.zsh
source $HOME/.zsh/config.zsh
source $HOME/.zsh/functions.zsh
[ -f $HOME/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source ~/.p10k.zsh
