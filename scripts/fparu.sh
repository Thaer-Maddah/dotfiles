#!/bin/bash
# https://github.com/junegunn/fzf/wiki/examples
#
# Install packages using paru (change to pacman/AUR helper of your choice)
function install() {
    paru -Slq | fzf -q "$1" -m --preview 'paru -Si {1}'| xargs -ro paru -S
}
# Remove installed packages (change to pacman/AUR helper of your choice)
function remove() {
    paru -Qq | fzf -q "$1" -m --preview 'paru -Qi {1}' | xargs -ro paru -Rns
}

# Calling function by command line 
# ps: look at alias file
"$@"
