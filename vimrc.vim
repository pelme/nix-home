" basics
syntax on
set hidden          " allow hidden buffers
set number          " show line numbers
set title           " show title in console title bar
set colorcolumn=100 " show a vertical line at 100 characters
set ignorecase      " case insensitive search
set nobackup        " do not keep a backup file
set modeline        " allow modeline
set shiftwidth=4    " autoindent to 4 spaces (=,<,>) by default
set expandtab       " insert spaces when pressing tab
set tabstop=4       " numbers of spaces of tab character
set noswapfile      " make vim work with watchdog
set nowritebackup   " avoid backup file
set cursorline      " highlight the current line

if has("autocmd")
    " Restore cursor position
    au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

    au BufRead,BufNewFile *.md set filetype=markdown
    au BufRead,BufNewFile *.txt set filetype=markdown
endif

" shortcuts
let mapleader = ","

nmap <leader>w :w<cr>
nmap <leader>x :x<cr>
nmap <silent> <leader>/ :nohlsearch<cr>  " clear search highlight
" search/replace current word
nnoremap <leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap S diw"0P " 'stamp' the word under the cursor

map <leader>e :e ~/.vimrc<cr>      " edit my .vimrc file

let g:jedi#use_tabs_not_buffers = 0
let g:jedi#use_splits_not_buffers = "bottom"
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#usages_command = ""
nnoremap <leader>f :CtrlSF<space>

" yank to system clipboard
vmap <leader>y "*y
nmap <leader>y "*y

nmap <leader>t :CtrlP<cr>
nmap <leader>b :CtrlPBuffer<cr>

nnoremap <leader>d :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <leader><leader> :b#<cr>  " switch to last buffer
nnoremap <C-Left> :vertical resize -1<cr>  " ctrl+arrow keys to resize splits
nnoremap <C-Down> :resize +1<cr>
nnoremap <C-Up> :resize -1<cr>
nnoremap <C-Right> :vertical resize +1<cr>
nnoremap <leader>v :vertical size 105<cr>

set splitright  " open vertical splits to the right

" make it possible to easily create new files in the same directories as
" existing files by typing %%
cabbr <expr> %% expand('%:p:h')

" theming and colors
set background=dark
colorscheme one

" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
