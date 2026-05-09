#!/bin/bash

echo "Installing packages to support Ruby"
sudo apt install \
  autoconf \
  build-essential \
  libdb-dev \
  libffi-dev \
  libgdbm-dev \
  libgdbm6 \
  libgmp-dev \
  libncurses5-dev \
  libreadline6-dev \
  libssl-dev \
  libyaml-dev \
  patch \
  uuid-dev \
  zlib1g-dev

echo "Installing utilities"
sudo apt install \
  bind9-dnsutils \
  dict \
  direnv \
  fzf \
  git \
  jq \
  libsqlite3-dev \
  pandoc \
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
echo "# mise (runtime version manager)"
echo "################################################################################"

if command -v mise &>/dev/null; then
  echo "mise is already installed"
else
  echo "Installing mise"
  curl https://mise.run | sh
fi

echo "Symlinking mise config"
mkdir -p "$HOME/.config/mise"
ln -nsf "$(pwd)/config/mise/config.toml" "$HOME/.config/mise/config.toml"

echo "Installing runtimes via mise"
"$HOME/.local/bin/mise" install

echo ""
echo "################################################################################"
echo "# Rust & Crates"
echo "################################################################################"

rustup default stable
rustup upgrade
# shellcheck source=/dev/null
. "$HOME/.cargo/env"
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
