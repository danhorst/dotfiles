execute pathogen#infect()
syntax on
filetype plugin indent on

let mapleader=","

set autoindent    " Always set autoindenting on
set copyindent    " Copy the previous indentation on autoindenting
set expandtab     " Use spaces instead of tabs
set hidden        " Allow buffers to be hidden
set hlsearch      " Highlight search terms
set ignorecase    " Ignore case when searching
set incsearch     " Show search matches as you type
set nobackup      " Backup files are not needed
set nowrap        " Don't wrap lines
set number        " Always show line numbers
set shiftround    " Use multiple of shiftwidth when indenting with '<' and '>'
set shiftwidth=2  " Number of spaces to use for autoindenting
set showmatch     " Set show matching parenthesis
set smartcase     " Ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab      " Insert tabs on the start of a line according to shiftwidth, not tabstop
set tabstop=2     " A tab is 2 spaces

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Fix Delete key
:fixdel

" Save time on EVERY vim command
nnoremap ; :

" Clear search pattern
nmap <silent> <leader>z :let @/ = ""<CR>

" Remember last position in file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Strip trailing whitespace
function! <SID>StripTrailingWhitespace()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
nmap <silent> <Leader><space> :call <SID>StripTrailingWhitespace()<CR>

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

nnoremap \ :Ag<SPACE>

" Enable airline
let g:airline#extensions#tabline#enabled = 1

" Writing prose is different than writing code
function! <SID>SetUpMarkdown()
  setlocal noexpandtab
  setlocal nonumber
  setlocal spell
  setlocal softtabstop=2
  setlocal tabstop=2
  setlocal wrap
  colorscheme pencil
endfunction
autocmd BufRead,BufNewFile *.md :call <SID>SetUpMarkdown()

" Word completion
set complete+=kspell

" Appearance
set guifont=Fira\ Mono:h16
