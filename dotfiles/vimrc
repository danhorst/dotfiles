set visualbell
execute pathogen#infect()
syntax on
filetype plugin indent on

let mapleader = ","

:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/

fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

command! TrimWhitespace call TrimWhitespace()
noremap <Leader>w :call TrimWhitespace()

set sw=2
set ts=2
set expandtab

:autocmd Filetype ruby set sw=2
:autocmd Filetype ruby set ts=2
:autocmd Filetype ruby set expandtab

:autocmd FileType gitcommit setlocal spell
