# Dotfiles

**personal configuration for zsh, prezto, termite and tmux and also a custom Vivaldi CSS**

**requirements:**
- \*NIX system 
- [zsh](https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH)
- [prezto](https://github.com/sorin-ionescu/prezto)
- [tmux](https://github.com/tmux/tmux)
- [oh-my-tmux](https://github.com/gpakosz/.tmux)
- [vivaldi](https://vivaldi.net)
- [conky](https://github.com/brndnmtthws/conky) 

**Installation:**
- git clone https://github.com/Madkita/Dotfiles
- copy termite config to .config/termite
- source agnoster theme in your .zshrc (if you don't want to use my .zshrc)
- copy the custom.css file to /opt/vivaldi(-snapshot)/resources/vivaldi/style
- excuse the command 'sudo sed -i '1s/^/@import "custom.css";/' common.css' (in vivaldi/style directory)
- copy .tmux.conf, .tmux.conf.local, .zshrc and .zpreztorc and .zprezto folder  to your $HOME directory (your files will be overwritten!!)
- copy the Fatty folder to $HOME/.conky



![alt text](https://raw.githubusercontent.com/Madkita/Dotfiles/master/Screenshot_20171204_134757.png)

## conky


![alt text](https://raw.githubusercontent.com/Madkita/Dotfiles/master/Fatty/preview.png)