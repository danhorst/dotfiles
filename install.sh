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

if [ -d "$HOME/.rbenv" ]; then
  echo "rbenv is already installed"
else
  echo "Installing rbenv"
  git clone https://github.com/rbenv/rbenv.git "$HOME/.rbenv"
  cd "$HOME/.rbenv" && src/configure && make -C src
fi

if [ -f "$HOME/.vim/pack" ]; then
  echo "Vim packages are already set up"
else
  echo "Setting up vim packages"
  mkdir -p "$HOME/.vim/pack/danhorst/start" "$HOME/.vim/pack/danhorst/opt"
fi

if [ -f "$HOME/.vim/pack/danhorst/start/fugitive" ]; then
 echo "Fugative already set up";
else
  git clone https://github.com/tpope/vim-fugitive.git "$HOME/.vim/pack/danhorst/start/fugitive"
  vim -u NONE -c "helptags fugitive/doc" -c q
fi
