#!/usr/bin/env bash

# symlink configs
function stow_con() {
    declare -a dirs=($(ls -d */))
    ignore_list=("screens/" "tools/")

    # remove ignored directories from list
    for ignore in ${ignore_list[@]}; do
        dirs=(${dirs[@]/$ignore})
    done

    echo "Stowing directories: ${dirs[@]}"

    for dir in ${dirs[@]}; do
        stow ${dir}
        if $SCRIPT_DEBUG; then echo "${dir} stowed."; fi
    done
}

# apply konsave plasma profile
function apply_plasma() {
    if ! command -v konsave &>/dev/null; then
        echo "konsave not found — skipping Plasma profile."
        echo "Install it with: pip install konsave"
        return
    fi
    konsave -a Plasma-Round && echo "Plasma-Round profile applied."
}

stow_con

read -rp "Apply Plasma-Round konsave profile? [y/N] " answer
[[ "${answer,,}" == "y" ]] && apply_plasma
