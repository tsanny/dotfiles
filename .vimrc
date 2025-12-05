" --- General Settings ---
set nocompatible            " Disable Vi compatibility
filetype plugin indent on   " Enable filetype detection
syntax on                   " Enable syntax highlighting

" --- UI & Visuals ---
set number                  " Show line numbers
set relativenumber          " Relative numbers (good for jumping)
set cursorline              " Highlight current line
set title                   " Update terminal title
set wrap                    " Wrap long lines...
set linebreak               " ...at words, not chars

" --- Indentation ---
set expandtab               " Use spaces instead of tabs
set tabstop=4               " Tab width
set shiftwidth=4            " Indent width
set smartindent             " Smart auto-indent

" --- Search ---
set ignorecase              " Case insensitive...
set smartcase               " ...unless capital used
set incsearch               " Show match while typing
set hlsearch                " Highlight matches

" --- Netrw (File Explorer) ---
let g:netrw_banner = 0      " Hide banner
let g:netrw_liststyle = 3   " Tree view
let g:netrw_winsize = 25    " 25% width

" --- File Finding ---
set path+=** " Recursive search
set wildmenu                " visual autocomplete for command menu
set wildmode=longest:full,full
set wildignore+=*.o,*.obj,*.class,*.pyc,*.swp,.git/*,node_modules/*

" --- Grep Setup ---
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
    set grepformat=%f:%l:%c:%m
endif

" --- Status Line ---
set statusline=%f\ %m\ %y\ %=%p%%\ %l:%c
set laststatus=2


" --- habamax, morning, desert ---
colorscheme habamax

" Sync with system clipboard seamlessly
if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" Trigger OSC 52 yank automatically when yanking into the system register (+)
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | OSCYankReg + | endif

" MAP: <leader>c to copy to system clipboard explicitly
vnoremap <leader>c :OSCYank<CR>
