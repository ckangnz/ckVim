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
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_palette = "original"
let g:gruvbox_material_background = 'hard'
colorscheme gruvbox-material

let g:airline_theme='gruvbox_material'
let g:airline_powerline_fonts = 1
let g:airline#extensions#ycm#enabled = 0
let g:airline#extensions#tabline#left_sep=''
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#close_symbol = '×'
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_left_sep = "\uE0B4"
let g:airline_right_sep = "\uE0B6"
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

"Hotkeys to edit with quickUI

let myPathsOpts={ "title": "Edit.." }
let myPaths=[]
call add(myPaths,['Help (&h)','vsp $HOME/.vim/notes/vimhelp.md'])
call add(myPaths,['-'])
call add(myPaths,['Vimrc (&v)','vsp $MYVIMRC'])
call add(myPaths,['General (&g)','vsp $HOME/.vim/general.vim'])
call add(myPaths,['Plugin (&p)','vsp $HOME/.vim/plugins.vim'])
call add(myPaths,['-'])
call add(myPaths,['Zshrc (&z)','vsp $HOME/.zshrc'])
call add(myPaths,['Zsh Plugin (&P)','vsp $HOME/.vim/plugins.zsh'])
call add(myPaths,['-'])
call add(myPaths,['Install.sh (&i)','vsp $HOME/.vim/install.sh'])
call add(myPaths,['-'])
call add(myPaths,['/code (&c)','vsp $HOME/code'])
noremap <silent><leader>e :call quickui#context#open(myPaths, myPathsOpts)<cr>


"mattn/emmet-vim
let g:user_emmet_settings = {
            \  'javascript' : {
                \      'extends' :['jsx','tsx'],
                \  },
                \}

"arithran/vim-delete-hidden-buffers
nnoremap <Leader>Q :DeleteHiddenBuffers<CR>

"Valloric/MatchTagAlways
let g:mta_use_matchparen_group = 1
let g:mta_filetypes = {
            \ 'html' : 1,
            \ 'ejs' : 1,
            \ 'xhtml' : 1,
            \ 'xml' : 1,
            \ 'php' : 1,
            \ 'javascriptreact' : 1,
            \ 'typescriptreact' : 1,
            \}
nnoremap % :MtaJumpToOtherTag<cr>

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
nnoremap <silent><Leader>gfo :AsyncRun git fetch origin
nnoremap <silent><Leader>gfa :AsyncRun git fetch --all --prune<cr>
nnoremap <silent> <Leader>gof :Gbrowse<cr>

command! ToggleMerginal execute (exists("*fugitive#head") && len(fugitive#head())) ? ':MerginalToggle' : 'echoerr "Not in a git repo"'
if has("autocmd")
    autocmd BufReadPost fugitive://* set bufhidden=delete
endif

"tyru/open-browser.vim, tyru/open-browser-github.vim
let gitOpt = {'title':'GITHUB Menu'}
let githubMenu = []
call add(githubMenu , ['Open PR (&r)'                     , 'exec "OpenGithubPullReq #" . fugitive#head()'])
call add(githubMenu , ['Open current file (&f)' , 'Gbrowse'])
call add(githubMenu , ['Open project (&g)'         , 'OpenGithubProject'])
call add(githubMenu , ['Open issues (&i)'       , 'OpenGithubIssue'])
call add(githubMenu , ['Open pull requests (&p)'         , 'OpenGithubPullReq'])
noremap <silent><nowait><leader>go :call quickui#context#open(githubMenu, gitOpt)<cr>

"tpope/vim-repeat
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

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

"Yggdroot/indentLine "miyakogi/conoline.vim
map <silent> <Leader>ll :IndentLinesToggle<cr>
let g:indentLine_enabled = 0
let g:indentLine_setColors = 1
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_char_list = ['┊','|', '¦', '┆']
let g:indentLine_defaultGroup = 'SpecialKey'
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2

map <silent> <leader>lp :ConoLineToggle<cr>
let g:conoline_auto_enable = 1
let g:conoline_use_colorscheme_default_normal=1
let g:conoline_use_colorscheme_default_insert=1

let concealMenu=[]
call add(concealMenu, ['Toggle Indent Lines(&l)', 'IndentLinesToggle'])
call add(concealMenu, ['Toggle Conoline(&p) ', 'ConoLineToggle'])
let concealOpt = {'title':'Conceal Menu'}
noremap <silent><nowait><leader>l :call quickui#listbox#open(concealMenu, concealOpt)<cr>

"godlygeek/tabular
nmap <Leader>T :Tabularize/
vmap <Leader>T :Tabularize/
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
      \ 'coc-vimlsp',
      \ 'coc-emmet',
      \ 'coc-css',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-yaml',
      \ 'coc-swagger',
      \ 'coc-prettier',
      \ 'coc-tsserver',
      \ 'coc-docker',
      \ 'coc-omnisharp',
      \ 'coc-eslint',
      \ 'coc-snippets'
      \]
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
"Floating scroll
nnoremap <silent><expr> <c-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<c-w><c-j>"
nnoremap <silent><expr> <c-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<c-w><c-k>"
inoremap <silent><expr> <c-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<c-w><c-j>"
inoremap <silent><expr> <c-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<c-w><c-k>"
vnoremap <silent><expr> <c-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<c-w><c-j>"
vnoremap <silent><expr> <c-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<c-w><c-k>"

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
  autocmd FileType javasccript,javascriptreact,typescript,typescriptreact,json setl formatexpr=CocActionAsync('formatSelected')
  autocmd FileType markdown let b:coc_suggest_disable = 1
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
let $FZF_DEFAULT_OPTS="--layout=reverse --bind ctrl-k:preview-up,ctrl-j:preview-down,?:toggle-preview"
let g:fzf_layout={'window':{ 'width': 0.9, 'height': 0.6 }}
let g:fzf_preview_window = ''
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-o': 'split',
            \ 'ctrl-v': 'vsplit' }
command! Ctrlp execute (exists("*fugitive#head") && len(fugitive#head())) ? ':GFiles' : ':Files'
nnoremap <silent> <C-p> :Ctrlp<CR>
nnoremap <silent> <C-e> :History<CR>
nnoremap <silent> <C-t> :Tags<CR>
nnoremap <Leader>f :Rg<space>
vnoremap <Leader>f y:Rg <c-r>"<cr>
nnoremap <Leader>F :Rg <c-r><c-w><cr>
nnoremap <Leader>@ :BCommits<cr>

autocmd! FileType fzf
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

"dominikduda/vim_current_word
let g:vim_current_word#highlight_current_word = 1
let g:vim_current_word#highlight_twins = 1
hi CurrentWord gui=bold,underline cterm=bold,underline
hi CurrentWordTwins gui=bold cterm=bold

"qxxb/vim-searchhi & inside/vim-search-pulse
let g:vim_search_pulse_disable_auto_mappings = 1
let g:vim_search_pulse_duration = 100
nmap <C-d> <C-d><Plug>Pulse
nmap <C-u> <C-u><Plug>Pulse
nmap <C-O> <C-O><Plug>Pulse
nmap <C-I> <C-I><Plug>Pulse
nmap gg gg<Plug>Pulse
nmap G G<Plug>Pulse
nmap % %<Plug>Pulse
nmap . .<Plug>Pulse
nmap / <Plug>(searchhi-/)
vmap / <Plug>(searchhi-v-/)
nmap n <Plug>(searchhi-n)<Plug>Pulse
nmap N <Plug>(searchhi-N)<Plug>Pulse
nmap * <Plug>(searchhi-*)<Plug>Pulse
nmap # <Plug>(searchhi-#)<Plug>Pulse
vmap n <Plug>(searchhi-v-n)<Plug>Pulse
vmap N <Plug>(searchhi-v-N)<Plug>Pulse
vmap * <Plug>(searchhi-v-*)<Plug>Pulse
vmap # <Plug>(searchhi-v-#)<Plug>Pulse
nmap <silent> <leader><space> <Plug>(searchhi-clear-all)
vmap <silent> <leader><space> <Plug>(searchhi-v-clear-all)
hi IncSearch cterm=none gui=none ctermbg=45 guibg=#40E0D0
hi Search ctermfg=black ctermbg=white guifg=black guibg=white
hi CurrentSearch cterm=reverse,bold gui=reverse,bold

"MattesGroeger/vim-bookmarks
hi BookmarkSign ctermbg=NONE ctermfg=red guibg=NONE guifg=red
hi BookmarkLine ctermbg=NONE ctermfg=NONE guibg=#343434 guifg=NONE
let g:bookmark_sign = '♥'
let g:bookmark_highlight_lines = 1
let g:bookmark_auto_close = 1
let g:bookmark_center = 1

let bookmarkMenu = []
call add(bookmarkMenu, ['Add/Delete bookmark (&m)', 'BookmarkToggle'])
call add(bookmarkMenu, ['Bookmark Annotate(&i)', 'BookmarkAnnotate'])
call add(bookmarkMenu, ['Bookmark Show all (&a)', 'BookmarkShowAll'])
call add(bookmarkMenu, ['-'])
call add(bookmarkMenu, ['Bookmark Next (&n)', 'BookmarkNext'])
call add(bookmarkMenu, ['Bookmark Previous (&p)', 'BookmarkPrev'])
call add(bookmarkMenu, ['-'])
call add(bookmarkMenu, ['Clear all bookmarks (&x)', 'BookmarkClearAll'])
let bookmarkOpt={'title':'Bookmarks'}
noremap <silent><nowait>m :call quickui#context#open(bookmarkMenu, bookmarkOpt)<cr>
"
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

"--------Testing vim-test/vim-test--------"
nmap <silent> <leader>tt :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tL :TestVisit<CR>
nmap <silent> <leader>tus :Jest --update-snapshot<CR>
nmap <silent> <leader>to :Cypress open -C ./*/**/cypress.json<CR>
let testMenu = [
            \ [ 'Test this (&t)'       , 'TestNearest' ]                         ,
            \ [ 'Test file (&f)'       , 'TestFile' ]                            ,
            \ [ 'Test suite (&s)'      , 'TestSuite' ]                           ,
            \ [ 'Test last (&l)'       , 'TestLast' ]                            ,
            \ [ 'Test visit (&v)'      , 'TestVisit' ]                           ,
            \ [ 'Update snapshot (&u)' , 'Jest --update-snapshot' ]              ,
            \ [ 'Open Cypress (&o)'    , 'Cypress open -c ./*/**/cypress.json' ] ,
            \]
let testOpt = {'title': 'Jest Test'}
map <silent><nowait><leader>t :call quickui#listbox#open(testMenu, testOpt)<cr>

let test#strategy = "asyncrun_background_term"
let g:test#javascript#runner = 'jest'
let g:test#javascript#options = '--update-snapshot'
let g:test#runner_commands= ['Jest','Cypress']

"-----------Docker skanehira/docker.vim-------------"
let dockerMenu = [
            \ [ 'Images (&i)', ':DockerImages' ],
            \ [ 'Containers (&c)', ':DockerContainers' ],
            \ [ 'Image Search (&s)', 'DockerImageSearch' ],
            \ [ 'Build with Tag (&b)', 'call DockerImageBuildWithTag()' ],
            \]
let dockerOpt = {'title': 'Docker Menu'}
map <silent><nowait><leader>d :call quickui#listbox#open(dockerMenu, dockerOpt)<cr>

function! DockerImageBuildWithTag()
    call inputsave()
    let t = input('Enter tag name: ')
    call inputrestore()
    let script = ':DockerImageBuild -t ' . t . ' .'
    if t!=""
        execute script
    endif
endfunction

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

"------------------------------------------------------------------
"skywind3000/vim-quickui-------------------
let g:quickui_border_style = 2
let g:quickui_color_scheme = 'gruvbox'
nnoremap <silent><nowait><leader>b :call quickui#tools#list_buffer('e')<cr>

let g:utilOpts = {'title': 'Utility Menu'}
let g:utilContent = []

call add(g:utilContent, [ 'NPM Run (&n)', 'call NpmRun()' ])
call add(g:utilContent, ['-'])

call add(g:utilContent, [ 'Generate GUID (&i)', 'call GenerateGUID()' ])
call add(g:utilContent, ['-'])

"universal-ctags/universal-ctags
nmap <Leader>ct :AsyncRun ctags -R .<cr>
call add(g:utilContent, [ 'Create Ctags (&t)', 'AsyncRun ctags -R' ])
call add(g:utilContent, ['-'])

"iamcco/markdown-preview.nvim
call add(g:utilContent, [ 'Markdown Preview (&d)', 'MarkdownPreview' ])
call add(g:utilContent, ['-'])

call add(g:utilContent, [ 'Clear Registers (&x)', 'call ClearReg()' ])

noremap <silent><nowait><leader>m :call quickui#context#open(g:utilContent, g:utilOpts)<cr>
"------------------------------------------------------------------
