" General settings
set nocompatible       " Latest Vim settings
set encoding=utf-8
set re=0
set noshowmode         " Hide --INSERT-- at the bottom
filetype plugin indent on
syntax on

" Terminal colors
if has('termguicolors')
  set termguicolors
endif

" Provider settings (disable unused providers)
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_node_provider = 0

" Python provider
if has('unix') && has('mac')
  let g:python3_host_prog = '/usr/bin/python3'
else
  let g:python3_host_prog = '/home/linuxbrew/.linuxbrew/bin/python3'
endif

" Display settings
set display+=lastline   " Show long lines
set nonumber           " No line numbers
set norelativenumber
set signcolumn=yes     " Show signcolumn
set ttyfast            " Fast typing/scrolling
set laststatus=2       " Always show status line

" Indentation
set autoindent         " Copy indent from previous line
set smartindent        " Smart indenting when { is used
set tabstop=2          " Default tabs
set expandtab          " Use space as tab
set softtabstop=2      " Width applied by tab
set shiftwidth=2       " Width of tab in normal mode

" Search settings
set autoread           " Auto refresh when file changed
set ignorecase         " Ignore case when searching
set smartcase          " Disable ignorecase when capitals used
set hlsearch           " Highlight search
set incsearch          " Show preview of search

" Behavior
set scrolloff=5        " Keep cursor away from edges
set backspace=indent,eol,start  " Make backspace normal
set noerrorbells
set novisualbell
set autowriteall       " Automatically write file
set complete=.,w,b,u   " Set autocomplete
set shortmess+=atT     " Get rid of press enter prompts
set updatetime=500     " Used for CursorHold
set nobackup           " Don't create backup files
set nowritebackup      " Don't write backup
set noswapfile         " Don't create swap files
set confirm            " Prompt when unsaved quits
set mouse=a            " Enable mouse

" Splits
set splitbelow         " Horizontal split below
set splitright         " Vertical split right
set diffopt+=vertical  " Vertical diffs

" GUI settings
set guifont=FiraCode\ Nerd\ Font:h12
set linespace=0
set wrapmargin=0
set textwidth=0
set guioptions-=e      " Disable tabline
set guioptions-=l      " Disable left scrollbar
set guioptions-=L      " Disable left scrollbar when split
set guioptions-=r      " Disable right scrollbar
set guioptions-=R      " Disable right scrollbar when split

" Cursor shapes
let &t_SI.="\e[5 q"   " Insert mode
let &t_SR.="\e[4 q"   " Replace mode
let &t_EI.="\e[1 q"   " Normal mode

" Line breaking
if has('linebreak')
  set breakindent
  set showbreak=󱞩\
  set cpoptions+=n
  set breakat=\ ^I!@*-+;:,./?
endif

" List characters
set list
set listchars=space:\ ,tab:»»,lead:·,trail:·,nbsp:◇,extends:▸,precedes:◂,multispace:····

" Fill characters
set fillchars=stl:\

" Folding
set foldcolumn=0
set foldlevel=99
set foldlevelstart=99

" Custom fold text function
function! StyliseFold()
  let line = '' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '|' . printf(" %10s", lines_count . ' lines' .. ' ◂') . ' |'
  let foldtextstart = strpart('▸' . repeat(' ', v:foldlevel*2). line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(' ', winwidth(0)-foldtextlength) .. foldtextend
endfunction
set foldtext=StyliseFold()

" Leader key
let mapleader = ','
let maplocalleader = ','

nnoremap ; :
vnoremap ; :
nnoremap ;; ;
vnoremap ;; ;

nnoremap - :Ex<CR>
