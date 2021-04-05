"-------------GENERAL SETTINGS-------------
syntax on                                       "Syntax ON
filetype plugin indent on
runtime macros
:filetype indent on

let mapleader = ','                             "The default leader is '\'
set re=0
set noimd                                       "Revert back to English when on different language
set nocompatible                                "Latest Vim Setting used
set encoding=utf-8
set t_CO=256                                    "Number of colours
set display+=lastline                           "Show long lines"
set autoindent                                  "Copy indent from previous line
set smartindent                                 "Smart indenting when { is used
set autoread                                    "Auto refresh when file has been changed
set ignorecase                                  "Ignores case when searching
set smartcase                                   "Disables ignorecase when capitals used
set so=10                                       "Keep cursor to not touch the bottom or top"
set backspace=indent,eol,start                  "Make backspace as normal
hi clear SignColumn                             "Disable signcolumn
set noerrorbells visualbell t_vb=               "No error bells
set autowriteall                                "Automatically writes file
set complete=.,w,b,u                            "Set autocomplete
set shortmess=a                                 "Get rid of Please press enter when opening a file"
set backupcopy=yes                              "Overwrite backupto original
set noswapfile                                  "Dont create swapfiles
set confirm                                     "Dont prompt when nonsaved quits
set mouse=a                                     "Click to position cursor always"
set splitbelow                                  "Horizontal split to below
set splitright                                  "Vertical split to right
set hlsearch                                    "highlight search
set incsearch                                   "Show preview of search
set diffopt+=vertical                           "Set split and diff to vertical

"GUI Adjust"
hi LineNr ctermbg=0 guibg=bg
hi vertsplit ctermbg=0 guibg=bg
hi foldcolumn ctermbg=0 guibg=bg guifg=white
hi SignColumn guibg=bg

"----------VISUALS---------
set guifont=FiraCode\ Nerd\ Font:h12            "Set font family
set linespace=10                                "Set line space
set wrapmargin=0                                "line number margins
set textwidth=0                                 "Set text width"
set nonumber                                    "No line numbers
"set number                                     Set line numbers"
"set relativenumber                             Set relative numbers"
set ttyfast                                     "Set typing fast/ scroll fast option"
set guioptions-=e                               "Disable tabline
set guioptions-=l                               "Disable scrollbars
set guioptions-=L
set guioptions-=r
set guioptions-=R
set tabstop=4                                   "Default tabs
set expandtab                                   "Use space as a tab
set softtabstop=4                               "Width applied by tab
set shiftwidth=4                                "Width of tab in normal mode
let &t_SI.="\e[5 q"                             "Cursor shape change in different mode
let &t_SR.="\e[4 q"
let &t_EI.="\e[1 q"
if has('linebreak')
    set breakindent
    let &showbreak = '↳ '
    set cpo+=n
    let &breakat = " \t;:,])}"
end
set list lcs=trail:·,tab:»»,nbsp:~              "Show whitespaces with symbol

"----------MAPPINGS---------
map ; :
noremap ;; ;
nmap j gj
nmap k gk
vmap j gj
vmap k gk
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
inoremap ∆ <Esc>:m .+1<CR>==gi
inoremap ˚ <Esc>:m .-2<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

"Hotkeys to edit
nmap <leader>ev :vsp $MYVIMRC<cr>
nmap <leader>ez :vsp ~/.zshrc<cr>
nmap <leader>eh :vsp ~/.vim/notes/vimhelp.MD<cr>
nmap <leader>ec :e ~/code<cr>
nmap <leader>en :vsp ~/.vim/notes<cr>
nmap <leader>eg :vsp ~/.vim/general.vim<cr>
nmap <leader>ep :vsp ~/.vim/plugins.vim<cr>
nmap <leader>pi :PlugInstall<cr>
nmap <leader>pu :PlugUpdate<cr>

"Panel Navigation
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>

"Terminal commands
tnoremap <Esc> <C-\><C-n>

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
nnoremap <Leader>bp :bp<cr>
nnoremap <Leader>bn :bn<cr>

"Search visually selected word
nmap <Leader><space> :nohlsearch<cr>
vnoremap // y/<C-R>"<CR>
"Find/ Search within visual block
vnoremap / <Esc>/\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
vnoremap ? <Esc>?\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l

"Folding
set foldmethod=syntax
:setlocal foldcolumn=0
let javascript_fold=1
set foldlevelstart=99
"Space to toggle folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
"Neat Folding
function! NeatFoldText()
    let line = '' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '|' . printf("%10s", lines_count . ' lines') . ' |'
    let foldtextstart = strpart('+' . repeat(' ', v:foldlevel*2). line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return foldtextstart . repeat(' ', winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()

"--------CUSTOM VIM SCRIPT------------
"To do notes
function! Todo()
    let fname= "~/.vim/notes/todo.md"
    let winnum=bufwinnr(fname)
    if winnum != -1
        exe winnum . "wincmd w"
    else
        exe "60vsp" .  fname
    endif
    call inputsave()
    let t = input('Enter todo: ')
    call inputrestore()
    if t !=""
        call append(line('$'), '- [ ] ' . t)
    endif
endfunction
nnoremap <Leader>n :call Todo()<CR>

"Change in between '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#'
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
  execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
  execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
  execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
  execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

"Toggle copen and cclose
autocmd FileType qf if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif "Quickfix to be full width on the bottom
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

nnoremap <silent> <Leader>4 :call ToggleQuickFix()<cr>

"clear register
function! ClearReg()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
    unlet regs
endfunction
nnoremap <Leader>Q :call ClearReg()<CR>
