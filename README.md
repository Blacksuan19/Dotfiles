# Dotfiles

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FBlacksuan19%2FDotfiles.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2FBlacksuan19%2FDotfiles?ref=badge_shield)
**personal configuration for zsh, prezto, termite, tmux, neofetch, firefox, libinput-gesture and conky and also a custom Vivaldi CSS**

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
- source command-time.config.zsh in your zshrc (if you dont want to use mine)
- copy the custom.css file to /opt/vivaldi(-snapshot)/resources/vivaldi/style
- excuse the command `sudo sed -i '1s/^/@import "custom.css";/' common.css` (in vivaldi/style directory)
- copy .tmux.conf, .tmux.conf.local, .zshrc and .zpreztorc to your $HOME directory (your existing files will be overwritten!!)
- copy the Fatty folder to $HOME/.conky
- copy userChrome.css to chrome folder under your firefox profile
- copy libinput-gesture.conf to $HOME/.config

scripts are available on a separate repo [here](http://github.com/madkita/Scripts)


## **Screenshots:**

#### terminal:
![alt text](https://raw.githubusercontent.com/Madkita/Dotfiles/master//Screens/Screenshot.png)


#### vivaldi:

![alt text](https://raw.githubusercontent.com/Madkita/Dotfiles/master/Screens/Screenshot_20180221_165653.png)

#### firefox:

![alt text](https://raw.githubusercontent.com/Madkita/Dotfiles/master/Screens/Screenshot_20180221_165718.png)
#### conky:

![alt text](https://raw.githubusercontent.com/Madkita/Dotfiles/master/Fatty/preview.png)

## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FBlacksuan19%2FDotfiles.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2FBlacksuan19%2FDotfiles?ref=badge_large)
