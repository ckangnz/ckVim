so ~/.vim/general.vim                           "General Vim settings
so ~/.vim/plugins.vim                           "Source the plugins
filetype plugin indent on
runtime macros
:filetype indent on

"---------------THEMES---------------
set background=dark
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_sign_column_background = 'none'
let g:gruvbox_material_disable_italic_comment = 1
let g:gruvbox_material_enable_italic = 0
let g:gruvbox_material_palette = "original"
let g:gruvbox_material_background = 'hard'
colorscheme gruvbox-material

hi Comment cterm=NONE
hi diffAdded ctermfg=142 guifg=#a9b665
hi diffRemoved ctermfg=167 guifg=#ea6962
hi RedundantSpaces ctermbg=red guibg=red
hi ExtraWhitespace ctermbg=red guibg=red
2match RedundantSpaces /\s\+$/
2match ExtraWhitespace /\s\+$/

let g:airline_theme='gruvbox_material'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#left_sep=''
let g:airline#extensions#ycm#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#close_symbol = '×'
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:asyncrun_open = 0
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
nnoremap <silent> <Leader>1 :Gstatus<cr><c-w>T
nnoremap <silent> <Leader>2 :GV --all<cr>
vnoremap <silent> <Leader>2 :GV!<cr>
nnoremap <silent> <Leader>3 :ToggleMerginal<cr>
nnoremap <silent> <Leader>gc :Gcommit<cr>
nnoremap <silent> <Leader>gr :Gread<cr>
nnoremap <silent> <Leader>gw :Gwrite<cr>
nnoremap <silent> <Leader>gd :Gdiff<cr>
nnoremap <silent> <Leader>gD :Gdiffsplit!<cr>
nnoremap <Leader>ge :Gedit<space>
nnoremap <silent> <Leader>gb :Git blame<cr>
nnoremap <silent> <Leader>gp :AsyncRun git -c push.default=current push<cr>
nnoremap <silent> <Leader>gP :AsyncRun Git push -f<cr>
nnoremap <silent> <Leader>gl :AsyncRun Git pull<cr>
nnoremap <Leader>gfo :AsyncRun Git fetch origin
nnoremap <Leader>gfa :AsyncRun Git fetch --all --prune<cr>
nnoremap <silent> <Leader>gof :Gbrowse<cr>
nnoremap <silent> <leader>df :diffupdate<cr>
vmap <silent> <leader>dp V:diffput<cr>
vmap <silent> <leader>do V:diffget<cr>

command! ToggleMerginal execute (exists("*fugitive#head") && len(fugitive#head())) ? ':MerginalToggle' : 'echoerr "Not in a git repo"'
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
map <silent> <Leader>l :let &cole=(&cole == 1) ? 0 : 1 <bar> echo 'conceallevel ' . &cole <CR>

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

"junegunn/fzf
set rtp+=/usr/local/opt/fzf
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-o': 'split',
            \ 'ctrl-v': 'vsplit' }
command! Ctrlp execute (exists("*fugitive#head") && len(fugitive#head())) ? ':GFiles' : ':Files'
nnoremap <C-p> :Ctrlp<CR>
nnoremap <C-e> :History<CR>
nnoremap <C-t> :Tags<CR>
nnoremap <Leader>f :Ag<space>
vnoremap <Leader>f y:Ag <c-r>"<cr>
nnoremap <Leader>F :Ag <c-r><c-w><cr>
nnoremap ? :BLines<CR>
vnoremap ? y:BLines <c-r><c-w><cr>
nnoremap <Leader>@ :BCommits<cr>
let spec = {'down':'~60%','options': '--delimiter : --nth 1..'}
let preview_window = 'up:60%'
command! -bang -nargs=? -complete=dir GFiles
            \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(spec, preview_window), <bang>0)
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(spec, preview_window), <bang>0)
command! -bang -nargs=* Ag
            \call fzf#vim#ag(<q-args>, fzf#vim#with_preview(spec, preview_window), <bang>0)
command! -bang -nargs=* History
            \call fzf#vim#history(fzf#vim#with_preview(spec, preview_window))

"dyng/ctrlsf.vim
nmap <C-F>f <Plug>CtrlSFPrompt
vmap <C-F>f <Plug>CtrlSFVwordExec
nmap <C-F>n <Plug>CtrlSFCwordPath
nmap <C-F>p <Plug>CtrlSFPwordPath
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>
let g:ctrlsf_regex_pattern = 1
let g:ctrlsf_auto_preview = 1
let g:ctrlsf_case_sensitive = 'no'
let g:ctrlsf_default_view_mode = 'compact'
let g:ctrlsf_search_mode = 'async'
let g:ctrlsf_mapping = {
            \ "next": "n",
            \ "prev": "N",
            \ }
let g:ctrlsf_position = 'bottom'
let g:ctrlsf_winsize = '50%'

"dominikduda/vim_current_word
let g:vim_current_word#highlight_current_word = 1
let g:vim_current_word#highlight_twins = 1

"MattesGroeger/vim-bookmarks
hi BookmarkSign ctermbg=NONE ctermfg=160
hi BookmarkLine ctermbg=194 ctermfg=NONE
let g:bookmark_sign = '♥'
let g:bookmark_highlight_lines = 1
let g:bookmark_auto_close = 1
let g:bookmark_center = 1

"mbbill/undotree
nnoremap <leader>u :UndotreeToggle<cr>
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 3

"sheerun/vim-polygot
let g:markdown_fenced_languages = ['html', 'css', 'scss', 'sql', 'js=javascript', 'go', 'py=python', 'bash=sh', 'c', 'ruby']

"sotte/presenting.vim
au FileType markdown let b:presenting_slide_separator = '\v(^|\n)\-{4,}'

"gabrielelana/vim-markdown
let g:markdown_enable_mappings = 1
let g:markdown_enable_spell_checking = 0
let g:markdown_enable_conceal = 1
let g:markdown_enable_folding = 1
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_fenced_languages = ['csharp=cs', 'js=javascript', 'sh=bash']

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
let g:ale_change_sign_column_color = 1
let g:ale_sign_error = '·'
let g:ale_sign_warning = '?'
let g:vim_vint_show_style_issues = 1
let g:ale_linters = {}
let g:ale_linters = {
            \'vim':['vint'],
            \'css':['stylelint'],
            \'typescript':['tsserver','eslint'],
            \'typescriptreact':['tsserver','eslint'],
            \'javascript':['eslint', 'flow', 'flow-language-server'],
            \'javascriptreact':['eslint', 'flow', 'flow-language-server'],
            \'python':['flake8', 'pylint'],
            \}
let g:ale_fixers = {
            \'*':['remove_trailing_lines', 'trim_whitespace'],
            \'css':['stylelint'],
            \'typescriptreact':['prettier', 'eslint'],
            \'typescript':['prettier', 'eslint'],
            \'javascriptreact':['prettier', 'eslint'],
            \'javascript':['prettier', 'eslint'],
            \'python':['autopep8', 'yapf'],
            \}
let g:ale_linters_explicit = 1
let g:ale_javascript_prettier_use_global = 0
let g:ale_javascript_prettier_eslint_executable = 'prettier_eslint'
let g:ale_fix_on_save = 1

"--------Testing vim-test/vim-test--------"
nmap <silent> <leader>tt :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tL :TestVisit<CR>

let test#strategy = "asyncrun_background_term"
let g:test#javascript#runner = 'jest'

"-----CTAGS--------"
"brew install --HEAD universal-ctags/universal-ctags/universal-ctags
nmap <Leader>ct :AsyncRun ctags -R .<cr>

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
