filetype plugin indent on
syntax enable

set smartindent
set expandtab
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype scss setlocal ts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=2 sw=2 expandtab
autocmd Filetype python setlocal ts=4 sw=4 expandtab
autocmd Filetype go setlocal ts=4 sw=4 expandtab
autocmd Filetype yaml setlocal ts=4 sw=4 expandtab

set number
set relativenumber

set incsearch
set smartcase
set ignorecase

" strip trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e
