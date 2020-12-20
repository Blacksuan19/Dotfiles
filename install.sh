#!/usr/bin/env bash

# install required fonts
function install_fonts() {
    target="$HOME/.local/share/fonts"
    mkdir -p $target

    # install apple SanFranciscoDisplay font
    curl https://codeload.github.com/AppleDesignResources/SanFranciscoFont/zip/master \
       --output SF.zip
    unzip -j SF.zip SanFranciscoFont-master/SanFranciscoDisplay-\* -d $target/SanFranciscoDisplay

    # install JetBrainsMono
    curl https://download-cf.jetbrains.com/fonts/JetBrainsMono-2.001.zip --output \
        JetBrainsMono.zip
    unzip -j JetBrainsMono.zip ttf\/JetBrainsMono\* -d $target/JetBrainsMono

    # cleanup
    rm SF.zip JetBrainsMono.zip

    # install JetBrainsMono nerd font
    curl https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete.ttf \
        --output $target/JetBrainsMono/JetBrains\ Mono\ Regular\ Nerd\ Font\ Complete.ttf

}

# symlink configs
function stow_con() {
    # ignored files list
    declare -a ignore_list=(".git"
                            ".gitignore"
                            ".gitmodules"
                            "README.md"
                            "screens"
                        )

    # go throw all files except ignore list
    for file in ~/.dotfiles/*; do
      if [ -d ${file} ] && [[ ! ${file} =~ ${ignore_list[@]} ]]; then
        stow $(basename $file)
        if $SCRIPT_DEBUG; then echo "$(basename $file) stowed."; fi
      fi
    done
}

stow_con
install_fonts
