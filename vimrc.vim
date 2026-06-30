set number          " show line numbers
set ignorecase      " case insensitive search
set nobackup        " do not keep a backup file
set noswapfile      " make vim work with watchdog
set shiftwidth=4    " autoindent to 4 spaces (=,<,>) by default
set tabstop=4       " numbers of spaces of tab character
set expandtab       " insert spaces when pressing tab

let mapleader = ","

nmap <silent> <leader>/ :nohlsearch<cr>  " clear search highlight
vmap <leader>y "*y  " copy to system clip board
nmap <leader>y "*y  " copy to system clip board

" make it possible to easily create new files in the same directories as
" existing files by typing %%
cabbr <expr> %% expand('%:p:h')
