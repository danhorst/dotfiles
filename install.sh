#!/bin/bash

echo "Symlinking dotfiles into $HOME"
dotfiles_directory="$(pwd)/dotfiles"
ls -1 "$dotfiles_directory" | xargs -i ln -nsf "$dotfiles_directory/{}" "$HOME/.{}"

echo "Symlinking scripts & utilities into $HOME/bin"
bin_directory="$(pwd)/bin"
ls -1 "$bin_directory" | xargs -i ln -nsf "$bin_directory/{}" "$HOME/bin/{}"
