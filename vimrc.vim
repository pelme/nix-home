syntax on

set hidden          " allow hidden buffers
set number          " show line numbers
set title           " show title in console title bar
set ignorecase      " case insensitive search
set nobackup        " do not keep a backup file
set modeline        " allow modeline
set shiftwidth=4    " autoindent to 4 spaces (=,<,>) by default
set expandtab       " insert spaces when pressing tab
set tabstop=4       " numbers of spaces of tab character
set noswapfile      " make vim work with watchdog
set nowritebackup   " avoid backup file
set cursorline      " highlight the current line
set splitright  " open vertical splits to the right

colorscheme one

let mapleader = ","

nmap <leader>w :w<cr>
nmap <leader>x :x<cr>
nmap <silent> <leader>/ :nohlsearch<cr>  " clear search highlight
vmap <leader>y "*y  " copy to system clip board
nmap <leader>y "*y  " copy to system clip board
nnoremap <leader><leader> :b#<cr>  " switch to last buffer

" make it possible to easily create new files in the same directories as
" existing files by typing %%
cabbr <expr> %% expand('%:p:h')

