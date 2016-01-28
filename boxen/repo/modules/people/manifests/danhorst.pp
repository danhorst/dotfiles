class people::danhorst {

  #############################################################################
  # non-App Store apps
  #############################################################################

  include chrome
  include github_for_mac
  include macvim
  include virtualbox

  #############################################################################
  # CLI utilities
  #############################################################################

  include ctags
  include git
  include tmux
  include vagrant
  include wkhtmltopdf

  #############################################################################
  # Homebrew Packages
  #############################################################################

  package {
    [
      'exercism',
      'libpng',
      'libtool',
      'graphviz',
      'git-flow',
      'go',
      'pngcrush',
      'the_silver_searcher',
      'wrk',
    ]:
  }

  #############################################################################
  # VIM
  # NOTE: Installing vim with boxen means managing your dotfiles with boxen too
  # https://github.com/boxen/puppet-vim
  #############################################################################

  include vim
  vim::bundle { 'bling/vim-airline': }
  vim::bundle { 'davidoc/taskpaper.vim': }
  vim::bundle { 'ecomba/vim-ruby-refactoring': }
  vim::bundle { 'elzr/vim-json': }
  vim::bundle { 'ervandew/supertab': }
  vim::bundle { 'godlygeek/tabular': }
  vim::bundle { 'groenewege/vim-less': }
  vim::bundle { 'jgdavey/vim-blockle': }
  vim::bundle { 'kana/vim-textobj-user': }
  vim::bundle { 'kchmck/vim-coffee-script': }
  vim::bundle { 'kien/ctrlp.vim': }
  vim::bundle { 'nelstrom/vim-textobj-rubyblock': }
  vim::bundle { 'pangloss/vim-javascript': }
  vim::bundle { 'reedes/vim-colors-pencil': }
  vim::bundle { 'scrooloose/nerdtree': }
  vim::bundle { 'scrooloose/syntastic': }
  vim::bundle { 'sickill/vim-pasta': }
  vim::bundle { 'slim-template/vim-slim': }
  vim::bundle { 'timcharper/textile.vim': }
  vim::bundle { 'tomtom/tcomment_vim': }
  vim::bundle { 'tpope/vim-cucumber': }
  vim::bundle { 'tpope/vim-endwise': }
  vim::bundle { 'tpope/vim-fugitive': }
  vim::bundle { 'tpope/vim-git': }
  vim::bundle { 'tpope/vim-haml': }
  vim::bundle { 'tpope/vim-markdown': }
  vim::bundle { 'tpope/vim-rails': }
  vim::bundle { 'tpope/vim-rbenv': }
  vim::bundle { 'tpope/vim-repeat': }
  vim::bundle { 'tpope/vim-surround': }
  vim::bundle { 'tpope/vim-vividchalk': }
  vim::bundle { 'tsaleh/vim-matchit': }
  vim::bundle { 'tsaleh/vim-shoulda': }
  vim::bundle { 'tsaleh/vim-tmux': }
  vim::bundle { 'vim-ruby/vim-ruby': }
  vim::bundle { 'vim-scripts/Gist.vim': }
  vim::bundle { 'vim-scripts/IndexedSearch': }
  vim::bundle { 'vim-scripts/jQuery': }
  vim::bundle { 'wincent/Command-T': }


  #############################################################################
  # Dotfiles
  #############################################################################

  $home = "/Users/${::boxen_user}"
  $dotfiles_dir = "${boxen::config::srcdir}/dotfiles"

  repository { $dotfiles_dir:
    source => "${::github_user}/dotfiles"
  }

  file { "${home}/bin":
    ensure  => link,
    target  => "${dotfiles_dir}/bin",
    require => Repository[$dotfiles_dir]
  }

  file { "${home}/.bash_aliases":
    ensure  => link,
    target  => "${dotfiles_dir}/bash_aliases",
    require => Repository[$dotfiles_dir]
  }

  file { "${home}/.cheat":
    ensure  => link,
    target  => "${dotfiles_dir}/cheat",
    require => Repository[$dotfiles_dir]
  }

  file { "${home}/.gitconfig":
    ensure  => link,
    target  => "${dotfiles_dir}/gitconfig",
    require => Repository[$dotfiles_dir]
  }

  file { "${home}/.go":
    ensure  => link,
    target  => "${dotfiles_dir}/go",
    require => Repository[$dotfiles_dir]
  }

  file { "${home}/.profile":
    ensure  => link,
    target  => "${dotfiles_dir}/profile",
    require => Repository[$dotfiles_dir]
  }

  file { "${home}/.timetrap.yaml":
    ensure  => link,
    target  => "${dotfiles_dir}/timetrap.yml",
    require => Repository[$dotfiles_dir]
  }

  file { "${home}/.tmux.conf":
    ensure  => link,
    target  => "${dotfiles_dir}/tmux.conf",
    require => Repository[$dotfiles_dir]
  }

  file { "${home}/.vimrc":
    ensure  => link,
    target  => "${dotfiles_dir}/vimrc",
    require => Repository[$dotfiles_dir]
  }
}
