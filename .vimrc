syntax on                               "Syntax ON
set nocompatible                        " Latest Vim Setting used 
set encoding=utf-8

so ~/.vim/plugins.vim                   "Source the plugins 

filetype plugin indent on

"Python Syntax
let g:python_highlight_all = 1
augroup EnableSyntaxHighlighting
    autocmd! BufWinEnter,WinEnter * nested if exists('syntax_on') && ! exists('b:current_syntax') && ! empty(&l:filetype) && index(split(&eventignore, ','), 'Syntax') == -1 | syntax enable | endif
    autocmd! BufRead * if exists('syntax_on') && exists('b:current_syntax') && ! empty(&l:filetype) && index(split(&eventignore, ','), 'Syntax') != -1 | unlet! b:current_syntax | endif
augroup END

"Custom ext highlighting
"au BufEnter,BufWrite * :syntax sync fromstart
"au BufNewFile,BufRead *.ejs set filetype=html
"au BufNewFile,BufRead *.vue set filetype=html
"au BufNewFile,BufRead *.hbs set filetype=html
"au BufRead,BufNewFile .py,.pyw,*.c,*.h match BadWhitespace /\s\+$/

"Javascript Syntax Concealing
set conceallevel=1

runtime macros
:filetype indent on
:set filetype=html
if has('linebreak')
  set breakindent
  let &showbreak = '↳ '
  set cpo+=n
  let &breakat = " \t;:,])}"
end
set display+=lastline                           "Show long lines"
set autoindent
set autoread
set smartindent
set ignorecase
set smartcase

set backspace=indent,eol,start                  "Make backspace as normal
let mapleader = ','                             "The default leader i '\'
highlight clear SignColumn
set noerrorbells visualbell t_vb=               "No error bells
set autowriteall                                "Automatically writes file
set complete=.,w,b,u                            "Set autocomplete
set shortmess=a                                 "Get rid of Please press enter when opening a file"
set backupcopy=yes
set noswapfile
set confirm

"----------Visuals---------"
let g:enable_bold_font = 1
let g:enable_italic_font = 1
set background=dark
colorscheme hybrid_reverse
let g:airline_theme='bubblegum'
let g:airline_powerline_fonts = 1

set t_CO=256
set guifont=Fira_Code:h12
set guioptions-=e
set linespace=10
set wrapmargin=0                                "line number margins
set textwidth=0
"set nonumber                                   "No line numbers
"set number                                     Set line numbers"
"set relativenumber                             Set relative numbers"
set ttyfast                                     "Set typing fast/ scroll fast option"

set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
set tabstop=4                                   "Default tabs
set expandtab                                   "Use space as a tab
set softtabstop=4                               "Width applied by tab
set shiftwidth=4                                "Width of tab in normal mode

set list lcs=trail:·,tab:»»,nbsp:~

"GUI Adjust"
hi LineNr ctermbg=0 guibg=bg
:setlocal foldcolumn=2
hi foldcolumn ctermbg=bg guibg=bg
hi vertsplit ctermbg=0 guibg=bg

"Fold
nmap <Leader>zf V$%zf

"Enable cli
nmap <Leader>cli :!<space>

"------Split Management------"
set splitbelow
set splitright

"Moving hjkl long lines 
nmap j gj
nmap k gk
vmap j gj
vmap k gk

"Ctrl J K H L to navigate splits
nmap <C-J> <C-W><C-J>      	
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>

"----------VIM Mapping ---------"
nmap ,ev :vsp $MYVIMRC<cr>
nmap ,eh :vsp ~/.vim/vimhelp.MD<cr>
nmap ,en :vsp ~/.vim/notes<cr>
nmap ,ep :vsp ~/.vim/plugins.vim<cr>
nmap ,pi :PluginInstall<cr>

"Previous Page
nmap <Leader><Leader>m :bp<cr>
nmap <Leader><Leader>. :bn<cr>

"Simple highlight remove Press , <space> to highlight search
nmap <Leader><space> :nohlsearch<cr>

"Mapping ; to :. ;; mapped to ;
map ; :
noremap ;; ;

"---------------Panes---------------
"vsp / sp for splitting
",wf maximise ,wm minimise pane
",ww -> ,ww to change pane
",bp ,bn change panes
nnoremap <Leader>wf <C-W>\|
nnoremap <Leader>wm <C-W>=
nnoremap <Leader>wt <C-W>T
nnoremap <Leader>bp :bp<cr>
nnoremap <Leader>bn :bn<cr>

"----------------Indentation Visible by ,ig-----------
let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1
hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey

"--------Matching Tag Highlight -----
let g:mta_use_matchparen_group = 1
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'ejs' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'php' : 1,
    \}
"
"--------Vim Instant Markdown--------------------
let g:instant_markdown_autostart = 0
nnoremap <Leader>md :InstantMarkdownPreview<cr>

"---------Vim Fugitive (Vim Git)-------
nnoremap <Leader>gst :Gstatus<cr><c-w>T
nnoremap <Leader>gr :Gread<cr>
nnoremap <Leader>gw :Gwrite<cr>
nnoremap <Leader>gd :Gdiff<cr>
nnoremap <Leader>ge :Gedit<space>
nnoremap <Leader>gb :MerginalToggle<cr>
nnoremap <Leader>gB :Gblame<cr>
nnoremap <Leader>gl :GV --decorate --all<cr>
nnoremap <Leader>gL :silent! Glog<cr>:bot copen<cr>
set diffopt+=vertical
if has("autocmd")
    autocmd BufReadPost fugitive://* set bufhidden=delete
endif

"-----------Tabular ------------------
if exists(":Tabularize")
  nmap <Leader>ta :Tabularize /
  vmap <Leader>ta :Tabularize /
endif

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

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

"-----You Complete ME (YCM)-------
let g:ycm_disable_for_files_larger_than_kb = 0
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:ycm_key_list_stop_completion = ['<cr>']

"--------UltiSnips-----
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"--------Super Tab-----
let g:SuperTabDefaultCompletionType = '<C-n>'
"let g:SuperTabCrMapping=1
let g:SuperTabClosePreviewOnPopupClose = 1
autocmd FileType *
  \ if &omnifunc != '' |
  \   call SuperTabChain(&omnifunc, "<c-p>") |
\ endif

"----------Searching---------"
set hlsearch
set incsearch
vnoremap // y/<C-R>"<CR>
"Search visuall selected word

"-----ctags--------"
nmap <Leader>F :tag<space>
nmap <Leader>ct :!ctags -R .<cr>
"MAKE SURE :ctags -R to make things work"

"-----Ack Find from all files // Greplace to Change from all files--------"
nnoremap <Leader>f :Ack!<space>
let g:ackprg = "ag --vimgrep -i --group --follow --match"
let g:ack_wildignore=0

"----- Find/ Search within visual block------"
vnoremap / <Esc>/\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
vnoremap ? <Esc>?\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l

"Greplace.vim
nnoremap <Leader>h :Gsearch<cr>
set grepprg=ack
let g:grep_cmd_opts = '--noheading'

"------CtrlP Plugin-----"
nmap <C-p> :CtrlP<cr>
nmap <C-t> :CtrlPBufTag<cr>
nmap <C-e> :CtrlPMRUFiles<cr>
"Ctrl P view setting
let g:ctrlp_match_window = 'top,order:ttb,min:1,max:20,results:20'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|\.git$\|prod\'
let g:ctrlp_mruf_relative = 1
nmap <F5> :CtrlPClearCache<cr>

"-----General Navigation --------
nmap <Leader>pp :e package.json<cr>

"-----Python ----------
nmap <Leader>im :ImportName

"-----Node Express Commands-------
nmap <Leader>na :e keystone.js<cr>
nmap <Leader>nv :e templates/views/<cr>
nmap <Leader>nc :e routes/views/<cr>
nmap <Leader>nm :e models/<cr>
nmap <Leader>nr :e routes/<cr>
nmap <Leader>ns :e public/styles/<cr>
nmap <Leader>nj :e public/js/<cr>
nmap <Leader>nf :e config/<cr>

"-----Auto-Commands------"
"Auto sourcing self
augroup autosourcing
	autocmd!
	autocmd BufWritePost .vimrc source %
augroup END

