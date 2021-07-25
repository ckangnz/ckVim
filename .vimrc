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
nnoremap <silent> <Leader>1 :Git<cr><c-w>T
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
nnoremap <silent> <Leader>gP :AsyncRun git push -f<cr>
nnoremap <silent> <Leader>gl :AsyncRun git pull<cr>
nnoremap <Leader>gfo :AsyncRun :Git fetch origin
nnoremap <Leader>gfa :AsyncRun :Git fetch --all --prune<cr>
nnoremap <silent> <Leader>gof :Gbrowse<cr>

command! ToggleMerginal execute (exists("*fugitive#head") && len(fugitive#head())) ? ':MerginalToggle' : 'echoerr "Not in a git repo"'
if has("autocmd")
    autocmd BufReadPost fugitive://* set bufhidden=delete
endif

"tpope/vim-repeat
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

"tyru/open-browser.vim, tyru/open-browser-github.vim
nnoremap <Leader>go. :OpenGithubProject<cr>
nnoremap <Leader>goi :OpenGithubIssue<cr>
nnoremap <Leader>gop :OpenGithubPullReq<cr>
nnoremap <Leader>gor :exec "OpenGithubPullReq #" . fugitive#head()<cr>

"skywind3000/asyncrun.vim
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

"pangloss/vim-javascript
highlight Conceal guifg=fg guibg=bg
augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
    au FileType typescript setlocal foldmethod=syntax
augroup END
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

"Yggdroot/indentLine
map <silent> <Leader>ll :IndentLinesToggle<cr>
let g:indentLine_enabled = 0
let g:indentLine_setColors = 1
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_char_list = ['┊','|', '¦', '┆']
let g:indentLine_defaultGroup = 'SpecialKey'
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2

"miyakogi/conoline.vim
map <silent> <leader>lp :ConoLineToggle<cr>
let g:conoline_auto_enable = 1
let g:conoline_use_colorscheme_default_normal=1
let g:conoline_use_colorscheme_default_insert=1

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

"neoclide/coc.nvim
let g:coc_user_config = {}
let g:coc_global_extensions = [
      \ 'coc-emmet',
      \ 'coc-css',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-jest',
      \ 'coc-yaml',
      \ 'coc-swagger',
      \ 'coc-prettier',
      \ 'coc-tsserver',
      \ 'coc-docker',
      \ 'coc-omnisharp',
      \ 'coc-eslint',
      \ 'coc-snippets'
      \]
let g:coc_fzf_preview='right:50%'
let g:coc_fzf_opts=[]
nmap <silent>gd <Plug>(coc-definition)
nmap <silent>gy <Plug>(coc-type-definition)
nmap <silent>gi <Plug>(coc-implementation)
nmap <silent>gr <Plug>(coc-references)
nmap <silent><S-r> <Plug>(coc-rename)
xmap <leader>0 <Plug>(coc-format-selected)
nmap <leader>0 <Plug>(coc-format)
xmap <leader>ac <Plug>(coc-codeaction-selected)
nmap <leader>ac <Plug>(coc-codeaction-selected)
nmap <leader>ap <Plug>(coc-diagnostic-prev)
nmap <leader>an <Plug>(coc-diagnostic-next)
nmap <leader>. <Plug>(coc-codeaction)
nmap <leader>. <Plug>(coc-fix-current)
nnoremap <silent><nowait> gs :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> ? :<C-u>CocList outline<CR>

command -nargs=0 Swagger :CocCommand swagger.render
command! -nargs=0 Prettier :CocCommand prettier.formatFile
command! -nargs=0 Format : call CocActionAsync('format')
command! -nargs=? Fold   : call CocActionAsync('fold', <f-args>)
command! -nargs=0 OR     : call CocActionAsync('runCommand', 'editor.action.organizeImport')

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

augroup mygroup
  autocmd!
  autocmd FileType typescript,json setl formatexpr=CocActionAsync('formatSelected')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

"Omnisharp/omnisharp-vim
augroup omnisharp_commands
    autocmd!
    autocmd CursorHold *.cs OmniSharpTypeLookup
    autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
    autocmd FileType cs nmap <silent> <buffer> gu <Plug>(omnisharp_find_usages)
    autocmd FileType cs nmap <silent> <buffer> gi <Plug>(omnisharp_find_implementations)
    autocmd FileType cs nmap <silent> <buffer> gt <Plug>(omnisharp_type_lookup)
    autocmd FileType cs nmap <silent> <buffer> g. <Plug>(omnisharp_documentation)
    autocmd FileType cs nmap <silent> <buffer> gs <Plug>(omnisharp_find_symbol)
    autocmd FileType cs nmap <silent> <buffer> gf <Plug>(omnisharp_fix_usings)
    autocmd FileType cs nmap <silent> <buffer> <C-n> <Plug>(omnisharp_signature_help)
    autocmd FileType cs imap <silent> <buffer> <C-n> <Plug>(omnisharp_signature_help)
    autocmd FileType cs nmap <silent> <buffer> g= <Plug>(omnisharp_global_code_check)
    autocmd FileType cs nmap <silent> <buffer> <Leader>0 <Plug>(omnisharp_code_format)
    autocmd FileType cs nmap <silent> <buffer> <Leader>. <Plug>(omnisharp_code_actions)
    autocmd FileType cs xmap <silent> <buffer> <Leader>. <Plug>(omnisharp_code_actions)
    autocmd FileType cs nmap <silent> <buffer> <S-R> <Plug>(omnisharp_rename)
    autocmd FileType cs nmap <silent> <buffer> <Leader>oR <Plug>(omnisharp_restart_server)
    autocmd FileType cs nmap <silent> <buffer> <Leader>os <Plug>(omnisharp_start_server)
    autocmd FileType cs nmap <silent> <buffer> <Leader>oS <Plug>(omnisharp_stop_server)
    autocmd FileType cs nmap <silent> <buffer> <Leader>ob :call MakeSolution()<CR>
    autocmd FileType cs nmap <silent> <buffer> <Leader>or :call RunSolution()<CR>
    autocmd FileType cs nmap <buffer> <Leader>tt :OmniSharpRunTest<CR>
    autocmd FileType cs nmap <buffer> <Leader>tf :OmniSharpRunTestsInFile<CR>

    function! MakeSolution() abort
        let makeprg = 'dotnet build /nologo /v:m /property:GenerateFullPaths=true /clp:ErrorsOnly'
        let sln = fnamemodify(OmniSharp#FindSolutionOrDir(), ':.')
        setlocal errorformat=\ %#%f(%l\\\,%c):\ %m
        echomsg makeprg . sln
        call asyncrun#run(1, sln, makeprg)
    endfunction

    function! RunSolution() abort
        let sln = fnamemodify(OmniSharp#FindProjectOrDir(), ':.')
        echo sln
    endfunction

augroup END

"junegunn/fzf
set rtp+=/usr/local/opt/fzf
let $FZF_DEFAULT_OPTS="--bind ctrl-k:preview-up,ctrl-j:preview-down"
let g:fzf_layout={'down':'~60%'}
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
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
nnoremap <Leader>@ :BCommits<cr>

autocmd! FileType fzf
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler


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

"sotte/presenting.vim
let g:presenting_figlets = 1

"gabrielelana/vim-markdown
let g:markdown_enable_mappings = 1
let g:markdown_enable_spell_checking = 0
let g:markdown_enable_conceal = 1
let g:markdown_enable_folding = 1
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_fenced_languages = ['csharp=cs', 'js=javascript', 'sh=bash']

"kristijanhusak/vim-carbon-now-sh
let g:carbon_now_sh_options = {
            \'t':'monokai',
            \'ln':'false',
            \'fm':'Fira Code' }
vnoremap <leader>E :CarbonNowSh<CR>

"--------Testing vim-test/vim-test--------"
nmap <silent> <leader>tt :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tL :TestVisit<CR>
nmap <silent> <leader>tus :Jest --update-snapshot<CR>
nmap <silent> <leader>to :Cypress open -C ./*/**/cypress.json<CR>

let test#strategy = "asyncrun_background_term"
let g:test#javascript#runner = 'jest'
let g:test#runner_commands= ['Jest','Cypress']

"-----------Docker skanehira/docker.vim-------------"
nmap <leader>di :DockerImages<CR>
nmap <leader>dc :DockerContainers<CR>
nmap <leader>ds :DockerImageSearch<CR>
nmap <leader>db :call DockerImageBuildWithTag()<CR>

function! DockerImageBuildWithTag()
    call inputsave()
    let t = input('Enter tag name: ')
    call inputrestore()
    let script = ':DockerImageBuild -t ' . t . ' .'
    if t!=""
        execute script
    endif
endfunction

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
    autocmd BufWritePost $HOME/.vim/general.vim source $MYVIMRC
    autocmd BufWritePost $HOME/.vim/plugins.vim source $MYVIMRC
    autocmd BufWritePost $MYVIMRC AirlineRefresh
    autocmd BufWritePost $HOME/.vim/general.vim AirlineRefresh
    autocmd BufWritePost $HOME/.vim/plugins.vim AirlineRefresh
augroup END
