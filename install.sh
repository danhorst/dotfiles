#!/bin/bash

echo "Installing packages to support Ruby"
sudo apt install \
  autoconf \
  patch \
  build-essential \
  rustc \
  libssl-dev \
  libyaml-dev \
  libreadline6-dev \
  zlib1g-dev \
  libgmp-dev \
  libncurses5-dev \
  libffi-dev \
  libgdbm6 \
  libgdbm-dev \
  libdb-dev \
  uuid-dev

echo "Installing utilities"
sudo apt install \
  bind9-dnsutils \
  dict \
  direnv \
  git \
  libsqlite3-dev \
  spell \
  sqlite3 \
  tree

echo "Symlinking dotfiles into $HOME"
dotfiles_directory="$(pwd)/shell"
ls -1 "$dotfiles_directory" | xargs -i ln -nsf "$dotfiles_directory/{}" "$HOME/.{}"

echo "Symlinking scripts & utilities into $HOME/bin"
mkdir -p "$HOME/bin"
bin_directory="$(pwd)/bin"
ls -1 "$bin_directory" | xargs -i ln -nsf "$bin_directory/{}" "$HOME/bin/{}"

echo ""
echo "################################################################################"
echo "# Ruby"
echo "################################################################################"

if [ -d "$HOME/.rbenv" ]; then
  echo "rbenv is already installed"
else
  echo "Installing rbenv"
  git clone https://github.com/rbenv/rbenv.git "$HOME/.rbenv"
  cd "$HOME/.rbenv" && src/configure && make -C src
fi

if [ -d "$HOME/.rbenv/plugins/ruby-build" ]; then
  echo "ruby-build is already installed"
else
  echo "Installing ruby-build"
  mkdir -p "$HOME/.rbenv/plugins/ruby-build"
  git clone https://github.com/rbenv/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"
fi

echo ""
echo "################################################################################"
echo "# JavaScript"
echo "################################################################################"

if [[ $(type -t nvm) == function ]]; then
  echo "nvm is already installed"
else
  echo "Installing NVM"
  wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh" | bash
fi

# nvm install --lts
# npm install -g yarn

echo ""
echo "################################################################################"
echo "# Rust & Crates"
echo "################################################################################"

rustup default stable
cargo install bat
cargo install fd-find
cargo install git-delta
cargo install ripgrep

echo ""
echo "################################################################################"
echo "# Vim"
echo "################################################################################"

if [ -L "$HOME/.vim/spell" ]; then
  echo "Vim spelling is already up"
else
  echo "Setting up vim spelling"
  ln -nsf "$dotfiles_directory/spell" "$HOME/.vim/spell"
fi

vim_user="dbh"
vim_startup_plugin_path="$HOME/.vim/pack/$vim_user/start"
vim_opt_plugin_path="$HOME/.vim/pack/$vim_user/opt"

if [ -d "$HOME/.vim/pack" ]; then
  echo "Vim packages are already set up"
else
  echo "Setting up vim packages"
  mkdir -p "$vim_startup_plugin_path" "$vim_opt_plugin_path"
fi

if [ -d "$vim_startup_plugin_path/surround" ]; then
  echo "Surround already set up";
  git -C "$vim_startup_plugin_path/surround" pull
else
  echo "Installing surround";
  git clone git@github.com:tpope/vim-surround.git "$vim_startup_plugin_path/surround"
  vim -u NONE -c "helptags surround/doc" -c q
fi

if [ -d "$vim_startup_plugin_path/tagbar" ]; then
  echo "tagbar already set up";
  git -C "$vim_startup_plugin_path/tagbar" pull
else
  echo "Installing tagbar";
  git clone git@github.com:preservim/tagbar.git "$vim_startup_plugin_path/tagbar"
  vim -u NONE -c "helptags tagbar/doc" -c q
fi

if [ -d "$vim_startup_plugin_path/vim-ruby" ]; then
  echo "vim-ruby already set up";
  git -C "$vim_startup_plugin_path/vim-ruby" pull
else
  echo "Installing vim-ruby";
  git clone git@github.com:vim-ruby/vim-ruby.git "$vim_startup_plugin_path/vim-ruby"
  vim -u NONE -c "helptags vim-ruby/doc" -c q
fi
