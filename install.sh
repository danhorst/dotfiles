#!/bin/bash

if [ "$OSTYPE" = "linux-android" ]; then
  echo "Installing packages for Termux"
  pkg install debinautils openssh vim git tree

  if [ -d "$HOME/storage" ]; then
    echo "Storage is already set up"
  else
    termux-setup-storage
  fi
fi

echo "Symlinking dotfiles into $HOME"
dotfiles_directory="$(pwd)/config"
ls -1 "$dotfiles_directory" | xargs -i ln -nsf "$dotfiles_directory/{}" "$HOME/.{}"

echo "Symlinking scripts & utilities into $HOME/bin"
bin_directory="$(pwd)/bin"
ls -1 "$bin_directory" | xargs -i ln -nsf "$bin_directory/{}" "$HOME/bin/{}"

if [ -d "$HOME/.vim/bundle" ]; then
  echo "Pathogen is already installed"
else
  echo "Installing Pathogen"
  mkdir -p "$HOME/.vim/autoload" "$HOME/.vim/bundle"
  curl -LSso "$HOME/.vim/autoload/pathogen.vim" https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
fi
