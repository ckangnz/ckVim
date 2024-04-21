"*-*-*-*-*-*-GENERAL SETTINGS-*-*-*-*-*-*
let mapleader = ','                             "The default leader is '\'
let g:terminal_ansi_colors = [ '#546d79', '#ff5151', '#69f0ad', '#ffd73f', '#40c4fe', '#ff3f80', '#64fcda', '#fefefe', '#b0bec4', '#ff8980', '#b9f6c9', '#ffe47e', '#80d7fe', '#ff80ab', '#a7fdeb', '#fefefe',]
"black, dark red, dark green, brown, dark blue, dark magenta, dark cyan, light grey, dark grey, red, green, yellow, blue, magenta, cyan, white
let g:netrw_keepdir=0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:python3_host_prog="/usr/bin/python3"

if !exists('g:syntax_on')
  syntax on
  let g:syntax_on = 1
end
if !&termguicolors
  set termguicolors
endif
set re=0
set noimd                                       "Revert back to English when on different language
set noshowmode                                  "Hide --INSER-- at the bottom
set nocompatible                                "Latest Vim Setting used
set encoding=utf-8
set t_CO=256                                    "Number of colours
set display+=lastline                           "Show long lines"
set autoindent                                  "Copy indent from previous line
set smartindent                                 "Smart indenting when { is used
set autoread                                    "Auto refresh when file has been changed
set ignorecase                                  "Ignores case when searching
set smartcase                                   "Disables ignorecase when capitals used
set so=5                                        "Keep cursor to not touch the bottom or top"
set backspace=indent,eol,start                  "Make backspace as normal
set signcolumn=yes                              "Show signcolumn
set noerrorbells visualbell t_vb=               "No error bells
set autowriteall                                "Automatically writes file
set complete=.,w,b,u                            "Set autocomplete
set shortmess=atT                               "Get rid of Please press enter when opening a file"
set updatetime=500                              "Used for the CursorHold updatetime
set backupcopy=yes                              "Overwrite backupto original
set nobackup                                    "Dont create backupfile
set nowritebackup                               "Dont write backup
set noswapfile                                  "Dont create swapfiles
set confirm                                     "Dont prompt when nonsaved quits
set mouse=a                                     "Click to position cursor always"
set splitbelow                                  "Horizontal split to below
set splitright                                  "Vertical split to right
set hlsearch                                    "highlight search
set incsearch                                   "Show preview of search
set diffopt+=vertical                           "Set split and diff to vertical
set laststatus=2

"*-*-*-*-*-*-VISUALS-*-*-*-*-*-*
set guifont=FiraCode\ Nerd\ Font:h12                  "Set font family
set linespace=0                                 "Set line space
set wrapmargin=0                                "line number margins
set textwidth=0                                 "Set text width"
set nonumber                                   "No line numbers
"set number                                      "Set line numbers
"set relativenumber                             "Set relative numbers
set ttyfast                                     "Set typing fast/ scroll fast option"
set guioptions-=e                               "Disable tabline
set guioptions-=l                               "Disable scrollbars
set guioptions-=L
set guioptions-=r
set guioptions-=R
set tabstop=2                                   "Default tabs
set expandtab                                   "Use space as a tab
set softtabstop=2                               "Width applied by tab
set shiftwidth=2                                "Width of tab in normal mode
let &t_8f = "\e[38;2;%lu;%lu;%lum"              "Sets foreground color (ANSI, true-color mode)
let &t_8b = "\e[48;2;%lu;%lu;%lum"              "Sets background color (ANSI, true-color mode)
let &t_SI.="\e[5 q"                             "Cursor shape change in different mode
let &t_SR.="\e[4 q"
let &t_EI.="\e[1 q"

if has('linebreak')
  set breakindent
  let &showbreak ='﬌'
  set cpo+=n
  let &breakat = " ^I!@*-+;:,./?"
endif

"space = single space inbetween
"lead = spaces in the front
"trail = spaces in the end
"nbsp = alt + space
"tab = ctrl+v+tab
let g:markdown_recommended_style=0
set list lcs=space:\ ,lead:\ ,trail:·,nbsp:◇,tab:»»,extends:▸,precedes:◂,multispace:····,
"fillchars to remove ^ in status bar
"Ctrl + v -> 160 to write:  
set fillchars=stl: 

"*-*-*-*-*-*-NAVIGATION MAPPINGS-*-*-*-*-*-*
map ; :
noremap ;; ;
nmap j gj
nmap k gk
vmap j gj
vmap k gk
if has('unix') && has('mac')
  nnoremap <silent> ∆ :m .+1<CR>==
  nnoremap <silent> ˚ :m .-2<CR>==
  inoremap <silent> ∆ <Esc>:m .+1<CR>==gi
  inoremap <silent> ˚ <Esc>:m .-2<CR>==gi
  vnoremap <silent> ∆ :m '>+1<CR>gv=gv
  vnoremap <silent> ˚ :m '<-2<CR>gv=gv
else
  nnoremap <silent> <M-j> :m .+1<CR>==
  nnoremap <silent> <M-k> :m .-2<CR>==
  inoremap <silent> <M-j>∆ <Esc>:m .+1<CR>==gi
  inoremap <silent> <M-k>˚ <Esc>:m .-2<CR>==gi
  vnoremap <silent> <M-j>∆ :m '>+1<CR>gv=gv
  vnoremap <silent> <M-k>˚ :m '<-2<CR>gv=gv
endif
vnoremap <silent> <leader>y "+y
nmap <silent><C-O> <C-O>zz
nmap <silent><C-I> <C-I>zz
nmap <silent><C-D> <C-D>zz
nmap <silent><C-U> <C-U>zz

"*-*-*-*-*-*-PANEL NAVIGATION-*-*-*-*-*-*
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>
augroup vimrc
  au!

  "Tab movements
  noremap <c-t> :tabedit<cr>
  noremap g[ gT
  noremap g] gt

  autocmd FileType list noremap <buffer> <c-p> <c-p>
augroup END


"*-*-*-*-*-*-PANEL RESIZING-*-*-*-*-*-*
",wf maximise ,wm minimise pane
",wt open on a new tab
",wh to horizontal, wv to vertical
",ww -> ,ww to change pane
",bp ,bn change panes
nnoremap <Leader>wf <C-W>\|
nnoremap <Leader>wm <C-W>=
nnoremap <Leader>wh <C-W>t<C-W>K
nnoremap <Leader>wv <C-W>t<C-W>H
nnoremap <Leader>wt <C-W>T

"*-*-*-*-*-*-TERMINAL COMMANDS-*-*-*-*-*-*
tnoremap <Esc> <C-\><C-n>
if exists('g:neovide') || has('nvim')
  tnoremap <silent><expr> <c-j> pumvisible() > 0 ? "<c-j>" : "\<c-w><c-j>"
  tnoremap <silent><expr> <c-k> pumvisible() > 0 ? "<c-k>" : "\<c-w><c-k>"
else
  tnoremap <silent><expr> <c-j> len(popup_list()) > 0 ? "<c-j>" : "\<c-w><c-j>"
  tnoremap <silent><expr> <c-k> len(popup_list()) > 0 ? "<c-k>" : "\<c-w><c-k>"
endif
tnoremap <C-h> <C-w><C-h>
tnoremap <C-l> <C-w><C-l>

"*-*-*-*-*-*-FIND WORD OVERRIDES-*-*-*-*-*-*
"Clear search
nmap <silent> <Leader><space> :nohlsearch<cr>
"Find visually selected word
vnoremap // y/<C-R>"<CR>N
"Find/ Search within visual block
vnoremap / <Esc>/\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
vnoremap ? <Esc>?\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
"Show Highlight type pressing F10
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"*-*-*-*-*-*-CUSTOM FOLD STYLE-*-*-*-*-*-*
" set foldmethod=syntax
:setlocal foldcolumn=0
set foldlevel=99
set foldlevelstart=99

"Space to toggle folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
"Folded stype
func! StyliseFold()
  let line = '' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '|' . printf(" %10s", lines_count . ' lines' .. ' ◂') . ' |'
  let foldtextstart = strpart('▸' . repeat(' ', v:foldlevel*2). line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(' ', winwidth(0)-foldtextlength) .. foldtextend
endfunc
set foldtext=StyliseFold()

"*-*-*-*-*-*-CUSTOM COMMANDS-*-*-*-*-*-*
"Markdown overrides
autocmd FileType markdown inoremap <buffer><silent><nowait> <tab> <esc>>>A
autocmd FileType markdown inoremap <buffer><silent><nowait> <S-tab> <esc><<A

"SCSS override
autocmd FileType scss setl iskeyword+=@-@

"To do notes
func! Todo()
  call inputsave()
  let t = input('Enter todo: ')
  call inputrestore()
  if t !=""
    let fname = "~/.vim/notes/todo.md"
    let winnum = bufwinnr(fname)
    if winnum != -1
      exe winnum . "wincmd w"
    else
      exe "60vsp" .  fname
    endif
    if len(t) > 0 && t != " "
      call append(line('$'), '- [ ] ' . t)
    endif
  endif
endfunc
nnoremap <Leader>N :call Todo()<CR>

"Generate GUID
func GenerateGUID()
  let l:new_uuid=system('uuidgen')[:-2]
  let l:nuuid_case = "lower"
  let l:id= l:nuuid_case == "lower" ? tolower(l:new_uuid) : toupper(l:new_uuid)
  let @"=l:id
  echo "NEW GUID: " . l:id
endfunc

"Toggle copen and cclose
autocmd FileType qf if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif "Quickfix to be full width on the bottom
func! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix')) | copen | else | cclose | endif
endfunc
nnoremap <silent> <Leader>4 :call ToggleQuickFix()<cr>

"Clear all registers
func! ClearReg()
  let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
  for r in regs
    call setreg(r, [])
  endfor
  unlet regs
endfunc
