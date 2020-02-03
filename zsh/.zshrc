# only sourcing here!!
source /home/blacksuan19/.zprezto/init.zsh
export PATH=$HOME/bin:$PATH
export PATH=${PATH}:/home/blacksuan19/.gem/ruby/2.7.0/bin:$PATH
source /home/blacksuan19/.zsh/fast/fast-syntax-highlighting.plugin.zsh
source /home/blacksuan19/.zsh/config.zsh
source /home/blacksuan19/.zsh/functions.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
