#!/bin/bash

echo "Symlinking dotfiles into $HOME"
source_directory="$(pwd)/dotfiles"
ls -1 "$source_directory" | xargs -i ln -nsf "$source_directory/{}" "$HOME/.{}"
