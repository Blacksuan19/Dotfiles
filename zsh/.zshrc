# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# only sourcing here!!
source /home/blacksuan19/.zprezto/init.zsh
export PATH=$HOME/bin:$PATH
export PATH=${PATH}:/home/blacksuan19/.gem/ruby/2.6.0/bin:$PATH
export PATH=${PATH}:/home/blacksuan19/.gem/ruby/2.7.0/bin:$PATH
export PATH=${PATH}:/home/blacksuan19/go/bin:$PATH
source /home/blacksuan19/.zsh/fast/fast-syntax-highlighting.plugin.zsh
source /home/blacksuan19/.zsh/config.zsh
source /home/blacksuan19/.zsh/functions.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
