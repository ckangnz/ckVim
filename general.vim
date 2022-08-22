"-------------GENERAL SETTINGS-------------
let mapleader = ','                             "The default leader is '\'
let g:terminal_ansi_colors = [ '#546d79', '#ff5151', '#69f0ad', '#ffd73f', '#40c4fe', '#ff3f80', '#64fcda', '#fefefe', '#b0bec4', '#ff8980', '#b9f6c9', '#ffe47e', '#80d7fe', '#ff80ab', '#a7fdeb', '#fefefe',]
"black, dark red, dark green, dark yellow, dark blue, dark magenta, dark cyan, light grey, dark grey, red, green, yellow, blue, magenta, cyan, white

syntax on                                       "Syntax ON
set re=0
set noimd                                       "Revert back to English when on different language
set nocompatible                                "Latest Vim Setting used
set encoding=utf-8
set termguicolors
set t_CO=256                                    "Number of colours
set display+=lastline                           "Show long lines"
set autoindent                                  "Copy indent from previous line
set smartindent                                 "Smart indenting when { is used
set autoread                                    "Auto refresh when file has been changed
set ignorecase                                  "Ignores case when searching
set smartcase                                   "Disables ignorecase when capitals used
set so=10                                       "Keep cursor to not touch the bottom or top"
set backspace=indent,eol,start                  "Make backspace as normal
set signcolumn=yes                              "Show signcolumn
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

"----------VISUALS---------
set guifont=FiraCode\ Nerd\ Font:h12            "Set font family
set linespace=0                                "Set line space
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
end

"space = single space inbetween
"lead = spaces in the front
"trail = spaces in the end
"nbsp = alt + space
"tab = ctrl+v+tab
set list lcs=space:\ ,lead:\ ,trail:·,nbsp:◇,tab:»»,extends:▸,precedes:◂,multispace:····,

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
vnoremap <leader>y "+y

"Panel Navigation
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>
augroup vimrc
  au!
  autocmd FileType netrw call s:RemoveNetrwMap()
augroup END
function s:RemoveNetrwMap()
  if hasmapto('<Plug>NetrwRefresh')
    unmap <buffer> <C-L>
  endif
endfunction

"Terminal commands
tnoremap <Esc> <C-\><C-n>
tnoremap <silent><expr> <c-j> len(popup_list()) > 0 ? "<C-J>" : "\<C-W><C-J>"
tnoremap <silent><expr> <c-k> len(popup_list()) > 0 ? "<c-k>" : "\<c-w><c-k>"
tnoremap <C-H> <C-W><C-H>
tnoremap <C-L> <C-W><C-L>

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

"Search overrides
nmap <silent> <Leader><space> :nohlsearch<cr>
vnoremap // y/<C-R>"<CR>N

"Find/ Search within visual block
vnoremap / <Esc>/\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
vnoremap ? <Esc>?\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l

"Python Syntax
let g:python_highlight_all = 1

"Show Hilight type pressing F10
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"Folding
set foldmethod=syntax
:setlocal foldcolumn=0
set foldlevelstart=99
"Space to toggle folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
"Neat Folding
function! NeatFoldText()
    let line = '' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '|' . printf(" %10s", lines_count . ' lines' .. ' ◂') . ' |'
    let foldtextstart = strpart('▸' . repeat(' ', v:foldlevel*2). line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return foldtextstart . repeat(' ', winwidth(0)-foldtextlength) .. foldtextend
endfunction
set foldtext=NeatFoldText()

"--------CUSTOM VIM SCRIPT------------
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
    execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
    execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
    execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
    execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

"To do notes
function! Todo()
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
endfunction
nnoremap <Leader>n :call Todo()<CR>

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

function! ClearReg()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
    unlet regs
endfunction


func GenerateGUID()
    let l:new_uuid=system('uuidgen')[:-2]
    let l:nuuid_case = "lower"
    let l:id= l:nuuid_case == "lower" ? tolower(l:new_uuid) : toupper(l:new_uuid)
    let @"=l:id
    echo "NEW GUID: " . l:id
endfunction

func NpmSelected(id, result)
    let cmd = "npm run " . b:ks[a:result - 1]
    exec "terminal " . cmd
endfunc
function! NpmRun()
    if filereadable("./package.json")
        let st = readfile("./package.json")
        let package = json_decode(join(st, " "))
        if has_key(package, "scripts")
            let b:ks = keys(package.scripts)
            call popup_menu(b:ks, #{callback: 'NpmSelected'})
        endif
    else
        echo "No package.json found"
    endif
endfunction
