# Dotfiles

**personal configuration for zsh, prezto, termite and tmux and also a custom vivaldi CSS**

**requrements:**
- \*NIX system 
- zsh
- tmux
- vivaldi
- oh-my-tmux

**Installation:**
- 'git clone https://github.com/Madkita/Dotfiles'
- copy termite config to .config/termite
- source agnoster theme in your .zshrc (if you dont want to use my .zshrc)
- copy the custom.css file to /opt/vivaldi(-snapshot)/resources/vivaldi/style
- excuse the command 'sudo sed -i '1s/^/@import "custom.css";/' common.css' (in vivaldi/style directory)
- copy .tmux.conf and .tmux.conf.local and .zshrc and .zpreztorc and .zprezto folder  to your $HOME direcotry (your files will be overwritten!!)




![alt text](https://raw.githubusercontent.com/Madkita/Dotfiles/master/Screenshot_20171204_134757.png)