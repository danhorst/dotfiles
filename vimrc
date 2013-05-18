execute pathogen#infect()
syntax on
filetype plugin indent on

let mapleader=","

set hidden        " Allow buffers to be hidden
set nowrap        " Don't wrap lines
set tabstop=2     " A tab is 2 spaces
set backspace=indent,eol,start
                  " Allow backspacing over everything in insert mode
set autoindent    " Always set autoindenting on
set copyindent    " Copy the previous indentation on autoindenting
set number        " Always show line numbers
set shiftwidth=2  " Number of spaces to use for autoindenting
set shiftround    " Use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " Set show matching parenthesis
set ignorecase    " Ignore case when searching
set smartcase     " Ignore case if search pattern is all lowercase,
                  " case-sensitive otherwise
set smarttab      " Insert tabs on the start of a line according to
                  " shiftwidth, not tabstop
set hlsearch      " Highlight search terms
set incsearch     " Show search matches as you type
set nobackup      " Backup files are not needed

nnoremap ; :
                  " Save time on EVERY vim command

