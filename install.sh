#!/bin/bash

if [ "$OSTYPE" = "linux-android" ]; then
  echo "Installing packages for Termux"
  pkg install \
    clang \
    debianutils \
    git \
    make \
    openssh \
    tree
    vim \

  if [ -d "$HOME/storage" ]; then
    echo "Storage is already set up"
  else
    termux-setup-storage
  fi

  if [ -f "$HOME/.hushlogin" ]; then
    echo "Login message already suppressed"
  else
    echo "Suppressing login message"
    touch "$HOME/.hushlogin"
  fi
fi

echo "Symlinking dotfiles into $HOME"
dotfiles_directory="$(pwd)/config"
ls -1 "$dotfiles_directory" | xargs -i ln -nsf "$dotfiles_directory/{}" "$HOME/.{}"

echo "Symlinking scripts & utilities into $HOME/bin"
mkdir -p "$HOME/bin"
bin_directory="$(pwd)/bin"
ls -1 "$bin_directory" | xargs -i ln -nsf "$bin_directory/{}" "$HOME/bin/{}"

if [ -d "$HOME/.vim/bundle" ]; then
  echo "Pathogen is already installed"
else
  echo "Installing Pathogen"
  mkdir -p "$HOME/.vim/autoload" "$HOME/.vim/bundle"
  curl -LSso "$HOME/.vim/autoload/pathogen.vim" https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
fi

if [ -d "$HOME/.rbenv" ]; then
  echo "rbenv is already installed"
else
  echo "Installing rbenv"
  git clone https://github.com/rbenv/rbenv.git "$HOME/.rbenv"
  cd "$HOME/.rbenv" && src/configure && make -C src
fi
