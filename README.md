# Dotfiles

**personal configuration for zsh, prezto, termite, tmux, neofetch and conky and also a custom Vivaldi CSS**

## **Requirements:**
- \*NIX system 
- [Zsh](https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH)
- [Powerline Fonts](https://github.com/powerline/fonts)
- [Prezto](https://github.com/sorin-ionescu/prezto)
- [Tmux](https://github.com/tmux/tmux)
- [Oh-my-tmux](https://github.com/gpakosz/.tmux)
- [Neofetch](https://github.com/dylanaraps/neofetch/wiki/Installation)
- [Vivaldi](https://vivaldi.net)
- [Conky](https://github.com/brndnmtthws/conky) 

## **Installation:**
- git clone https://github.com/Madkita/Dotfiles
- copy termite config to .config/termite
- copy neofetch config to ~/.config/neofetch/
- source agnoster theme in your .zshrc (if you don't want to use my .zshrc)
- copy the custom.css file to /opt/vivaldi(-snapshot)/resources/vivaldi/style
- excuse the command `sudo sed -i '1s/^/@import "custom.css";/' common.css` (in vivaldi/style directory)
- copy .tmux.conf, .tmux.conf.local, .zshrc and .zpreztorc to your $HOME directory (your existing files will be overwritten!!)
- copy the Fatty folder to $HOME/.conky

scripts are available on a separate repo [here](http://github.com/madkita/Scripts)


## **Screenshots:**

#### terminal:
![alt text](https://raw.githubusercontent.com/Madkita/Dotfiles/master/Screenshot.png)

#### conky:


![alt text](https://raw.githubusercontent.com/Madkita/Dotfiles/master/Fatty/preview.png)