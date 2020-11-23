syntax on                                       "Syntax ON
set re=0
set noimd                                       "Revert back to English when on different language
set nocompatible                                "Latest Vim Setting used 
set encoding=utf-8
so ~/.vim/plugins.vim                           "Source the plugins 
filetype plugin indent on

"-------------GENERAL SETTINGS-------------
runtime macros
:filetype indent on
set t_CO=256                                    "Number of colours
set display+=lastline                           "Show long lines"
set autoindent                                  "Copy indent from previous line
set smartindent                                 "Smart indenting when { is used
set autoread                                    "Auto refresh when file has been changed
set ignorecase                                  "Ignores case when searching
set smartcase                                   "Disables ignorecase when capitals used
set so=10                                       "Keep cursor to not touch the bottom or top"
set backspace=indent,eol,start                  "Make backspace as normal
highlight clear SignColumn                      "Disable signcolumn
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
let mapleader = ','                             "The default leader is '\'

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

"Mappings
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

"highlight word under cursor - more options :so $VIMRUNTIME/syntax/hitest.vim
:autocmd CursorMoved * exe printf('match SpellLocal /\V\%%%dl\@!\<%s\>/', line('.'), escape(expand('<cword>'), '/\'))

"Folding
set foldmethod=syntax
:setlocal foldcolumn=0
let javascript_fold=1
set foldlevelstart=99
set fillchars=fold:\ 
"Space to toggle folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
"Neat Folding
function! NeatFoldText()
    let line = '' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '|' . printf("%10s", lines_count . ' lines') . '|'
    let foldchar = matchstr(&fillchars, 'fold:\zs.')
    let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2). line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()

"-------------SYNTAX HIGHLIGHTING-------------
"Python Syntax
let g:python_highlight_all = 1

"Custom ext highlighting
au BufNewFile,BufRead *.ejs,*.vue,*hbs set filetype=html
au BufNewFile,BufRead *.jsx,*.tsx set filetype=typescriptreact
au BufRead,BufNewFile .py,.pyw,*.c,*.h match BadWhitespace /\s\+$/

"---------------THEMES---------------
set background=dark
colorscheme hybrid_reverse

hi Comment ctermfg=243 guifg=#4a5158
hi ALEError guibg=#612E2D cterm=italic
hi def link typescriptBinaryOp Operator
hi def link typescriptParenExp Function
hi def link typescriptES6SetMethod Function
hi def link typescriptArrayMethod Function 

let g:airline_theme='hybrid'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#close_symbol = '×'
let g:airline#extensions#tabline#show_close_button = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:asyncrun_status = ''
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n' : 'N',
      \ 'i' : 'I',
      \ 'R' : 'R',
      \ 'c' : 'C',
      \ 'v' : 'V',
      \ 'V' : 'V',
      \ '' : 'V',
      \ 's' : 'S',
      \ 'S' : 'S',
      \ '' : 'S',
      \ }

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

let g:terminal_ansi_colors = [ '#546d79', '#ff5151', '#69f0ad', '#ffd73f', '#40c4fe', '#ff3f80', '#64fcda', '#fefefe', '#b0bec4', '#ff8980', '#b9f6c9', '#ffe47e', '#80d7fe', '#ff80ab', '#a7fdeb', '#fefefe',]
"black, dark red, dark green, dark yellow, dark blue, dark magenta, dark cyan, light grey, dark grey, red, green, yellow, blue, magenta, cyan, white

"-------------PLUGINS------------
"mattn/emmet-vim
let g:user_emmet_settings = {
\  'javascript' : {
\      'extends' :['jsx','tsx'],
\  },
\}

"arithran/vim-delete-hidden-buffers
nnoremap <Leader>q :DeleteHiddenBuffers<CR>

"Valloric/MatchTagAlways
let g:mta_use_matchparen_group = 1
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'ejs' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'php' : 1,
    \}
nnoremap <leader>% :MtaJumpToOtherTag<cr>

"easymotion/vim-easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
nmap F <Plug>(easymotion-overwin-f2)
hi link EasyMotionTarget DiffAdd
hi link EasyMotionShade  Comment
hi link EasyMotionTarget2First MatchParen
hi link EasyMotionTarget2Second MatchParen
hi link EasyMotionMoveHL Search
hi link EasyMotionIncSearch Search

"tpope/vim-fugitive / idanarye/vim-merginal / junegunn/gv.vim
nnoremap <Leader>1 :Gstatus<cr><c-w>T
nnoremap <Leader>2 :GV --all<cr>
vnoremap <Leader>2 :GV!<cr>
nnoremap <Leader>3 :MerginalToggle<cr>
nnoremap <Leader>gc :Gcommit<cr>
nnoremap <Leader>gr :Gread<cr>
nnoremap <Leader>gw :Gwrite<cr>
nnoremap <Leader>gd :Gdiff<cr>
nnoremap <Leader>ge :Gedit<space>
nnoremap <Leader>gb :Gblame<cr>
nnoremap <Leader>gp :exec "Gpush origin " . fugitive#head()<cr>
nnoremap <Leader>gP :Gpush -f<cr>
nnoremap <Leader>gl :Gpull<cr>
nnoremap <Leader>gof :Gbrowse<cr>
nnoremap <leader>df :diffupdate<cr>
vmap <silent> <leader>dp V:diffput<cr>
vmap <silent> <leader>do V:diffget<cr>
if has("autocmd")
    autocmd BufReadPost fugitive://* set bufhidden=delete
endif

"tyru/open-browser.vim, tyru/open-browser-github.vim
nnoremap <Leader>go. :OpenGithubProject<cr>
nnoremap <Leader>goi :OpenGithubIssue<cr>
nnoremap <Leader>gop :OpenGithubPullReq<cr>
nnoremap <Leader>gor :exec "OpenGithubPullReq #" . fugitive#head()<cr>

"skywind3000/asyncrun.vim
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

"pangloss/vim-javascript
highlight Conceal guifg=fg guibg=bg
let g:javascript_plugin_flow = 1
let g:javascript_conceal_function                  = "ƒ"
let g:javascript_conceal_null                      = "ø"
let g:javascript_conceal_this                      = "@"
let g:javascript_conceal_return                    = "⇚"
let g:javascript_conceal_undefined                 = "¿"
let g:javascript_conceal_NaN                       = "ℕ"
let g:javascript_conceal_prototype                 = "¶"
let g:javascript_conceal_static                    = "•"
let g:javascript_conceal_super                     = "Ω"
let g:javascript_conceal_arrow_function            = "⇒"
let g:javascript_conceal_noarg_arrow_function      = "○"
let g:javascript_conceal_underscore_arrow_function = "○"
map <leader>l :exec &conceallevel ? "set conceallevel=0" : "set conceallevel=1"<CR>

"godlygeek/tabular
nmap <Leader>ta :Tabularize/
vmap <Leader>ta :Tabularize/
inoremap <silent> <Bar> <Bar><Esc>:call <SID>align()<CR>a
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

"Valloric/YouCompleteMe
set completeopt+=popup
let g:ycm_auto_hover = ''
let g:ycm_disable_for_files_larger_than_kb = 0
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:ycm_key_list_stop_completion = ['<cr>']
nnoremap gd :YcmCompleter GoTo<cr>
nnoremap gy :YcmCompleter GoToType<cr>
nnoremap gr :YcmCompleter GoToReferences<cr>
nnoremap <leader>oi :YcmCompleter OrganizeImports<cr>
nnoremap R :call YCMRefactorRename()<cr>
nmap <silent> gh <plug>(YCMHover)

function! YCMRefactorRename()
  let n = input('Rename to : ')
  :exec "YcmCompleter RefactorRename " . n
endfunction

"SirVer/ultisnips
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsEditSplit="vertical"

"ervandew/supertab
let g:SuperTabDefaultCompletionType = '<C-n>'
let g:SuperTabCrMapping=1
let g:SuperTabClosePreviewOnPopupClose = 1
autocmd FileType *
  \ if &omnifunc != '' |
  \   call SuperTabChain(&omnifunc, "<c-p>") |
\ endif

"junegunn/fzf
set rtp+=/usr/local/opt/fzf
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>
let g:fzf_layout = {'down':'15~'}
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-o': 'split',
  \ 'ctrl-v': 'vsplit' }
nnoremap <C-p> :Files<CR>
nnoremap <C-e> :History<CR>
nnoremap <C-t> :Tags<CR>
nnoremap <Leader>f :Ag 
vnoremap <Leader>f y:Ag <c-r>"<cr>
nnoremap <Leader>F :Ag <c-r><c-w><cr>
nnoremap <Leader>r :Rg 
nnoremap ? :BLines<CR>
vnoremap ? y:BLines <c-r><c-w><cr>
nnoremap <Leader>@ :BCommits<cr>

command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(
            \   {'down':'~60%','options': '--delimiter : --nth 1..'},'up:60%','?'
            \), <bang>0)

command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>,
            \ fzf#vim#with_preview(
            \   {'down':'~60%','options': '--delimiter : --nth 4..'},'up:60%','?'
            \   ),)

command! -bang -nargs=* Rg call fzf#vim#grep('rg --line-number --column --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
            \ fzf#vim#with_preview(
            \   {'down':'~60%','options': '--delimiter : --nth 4..'},'up:60%','?'
            \   ),<bang>0)

"skwp/greplace.vim
nnoremap <Leader>h :Gsearch<cr>
set grepprg=ag
let g:grep_cmd_opts = '--noheading'

"mbbill/undotree
nnoremap <leader>u :UndotreeToggle<cr>
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 3

"gabrielelana/vim-markdown
let g:markdown_enable_spell_checking = 0
let g:markdown_enable_conceal = 1
let g:markdown_enable_folding = 1

"kristijanhusak/vim-carbon-now-sh
let g:carbon_now_sh_options = {
            \'t':'material',
            \'ln':'false',
            \'fm':'Fira' }
vnoremap <leader>C :CarbonNowSh<CR>

"w0rp/ale
nnoremap <leader><leader> :ALEToggle<cr>
nnoremap <leader>an :ALENext<cr>
nnoremap <leader>ap :ALEPrevious<cr>
nnoremap <leader>0 :ALEFix prettier<cr>

let g:ale_sign_column_always = 1
let g:ale_sign_error = '·'
let g:ale_sign_warning = '?'
let g:ale_linters = {
            \'css':['stylelint'],
            \'typescript':['tsserver','tslint'],
            \'javascript.jsx':['eslint', 'flow', 'flow-language-server'],
            \'javascript':['eslint', 'flow', 'flow-language-server'],
            \'python':['flake8', 'pylint'],
            \}
let g:ale_fixers = {
            \'css':['stylelint'],
            \'typescript':['tslint'],
            \'javascript':['eslint'],
            \'python':['autopep8', 'yapf'],
            \}
let g:ale_fix_on_save = 1

"--------Testing vim-test/vim-test--------"
nmap <silent> <leader>tt :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tL :TestVisit<CR>

let test#strategy = {
  \ 'nearest': 'vimterminal',
  \ 'file':    'vimterminal',
  \ 'suite':   'basic',
\}
let g:test#javascript#runner = 'jest'

"-----CTAGS--------"
"brew install --HEAD universal-ctags/universal-ctags/universal-ctags
nmap <Leader>ct :!ctags -R .<cr>

"--------VIM INSTANT MARKDOWN-------------
let g:instant_markdown_autostart = 0
nnoremap <Leader>md :InstantMarkdownPreview<cr>

"-----AUTO-COMMANDS------"
"Auto sourcing self
augroup autosourcing
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
	autocmd BufWritePost $MYVIMRC AirlineRefresh
augroup END

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

"clear register
function! ClearReg()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
      call setreg(r, [])
    endfor
    unlet regs
endfunction
nnoremap <Leader>Q :call ClearReg()<CR>
