" basics
syntax on
set hidden          " allow hidden buffers
set number          " show line numbers
set title           " show title in console title bar
set wildignore+=*.o,*.obj,*.bak,*.exe,*.pyc,*.png,*.jpg,*.gif,*.rdb,*.DS_Store,*.egg-info/**,*.db
set wildignore+=**/_build/**,**/external/**,**/CACHE/**,**/node_modules/**,**/bower_components/**
set wildignore+=**/build/**,**/assets/**,*.tar.gz,*.tar.bz2,**/venv/**,**/venv-*/**,**/.tox/**
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

noremap <leader>a :call jedi#goto_assignments()<cr>
noremap <leader>d :call jedi#goto_definitions()<cr>
noremap <leader>u :call jedi#usages()<cr>
nnoremap <leader>g :Gstatus<cr>
nnoremap <leader>c :Gcommit<cr>

" yank to system clipboard
vmap <leader>y "*y
nmap <leader>y "*y

nmap <leader>t :CtrlP<cr>
nmap <leader>b :CtrlPBuffer<cr>
imap jj <C-c>

nnoremap <leader>d :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <leader><leader> :b#<cr>  " switch to last buffer
nnoremap <C-Left> :vertical resize -1<cr>  " ctrl+arrow keys to resize splits
nnoremap <C-Down> :resize +1<cr>
nnoremap <C-Up> :resize -1<cr>
nnoremap <C-Right> :vertical resize +1<cr>
nnoremap <leader>v :vertical size 105<cr>

set splitright  " open vertical splits to the right
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>
if has('nvim')
nmap <BS> <C-W>h  " Workaround https://github.com/neovim/neovim/issues/2048
endif

" make it possible to easily create new files in the same directories as
" existing files by typing %%
cabbr <expr> %% expand('%:p:h')

" GUI/MacVim specific
set guifont=Source\ Code\ Pro:h14
set guioptions-=T  "  remove scrollbars and toolbars
set guioptions-=L  " ...
set guioptions-=r  " ...
set vb  " disable annoying audible bell in macvim

" theming and colors
if (has("termguicolors"))
set termguicolors  " enable lots of colors
endif
set background=dark
let g:oceanic_next_terminal_italic = 1 " enable italics, disabled by default
let g:oceanic_next_terminal_bold = 1 " enable bold, disabled by default
colorscheme one

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1  " non-block cursor in insert mode
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['es6'] = ''  " pretty icon for .es6 files

" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" create virtualenv with:
" $ new -p (which python3.5) neovim3
" $ pip install neovim
" $ new -p (which python2.7) neovim2
" $ pip install neovim
let g:python_host_prog=$HOME . '/.virtualenvs/neovim2/bin/python'
let g:python3_host_prog=$HOME . '/.virtualenvs/neovim3/bin/python'

let g:python_highlight_all = 1

" Stolen from https://github.com/blueyed/dotfiles/blob/12ff8d2572e5333ef4a11c0c56f630e8d0e4d13f/vimrc
command! -range=% -nargs=* Isort :<line1>,<line2>! isort --lines 79 <args> -
vmap <leader>i :Isort<cr>
nmap <leader>i :Isort<cr>
