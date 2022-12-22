so ~/.vim/general.vim                           "General Vim settings
so ~/.vim/plugins.vim                           "Source the plugins
runtime macros/sandwich/keymap/surround.vim

filetype plugin indent on
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
let g:airline#extensions#ycm#enabled = 0
let g:airline_left_sep = ""
let g:airline_right_sep = ""
let g:airline_section_y = airline#section#create(["%{coc#status()}%{get(b:,'coc_current_function','')}"])
let g:airline_section_z = airline#section#create(['%{g:airline_symbols.linenr}%#__accent_bold#%3l/%3L', '%{g:airline_symbols.colnr}%#__accent_bold#%3v'])
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#left_sep=''
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#right_alt_sep = '|'
let g:airline#extensions#tabline#close_symbol = '×'
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#coc#show_coc_status = 0

let g:asyncrun_open = 0
let g:airline_section_error = airline#section#create(['%{g:asyncrun_status}'])
let g:airline_mode_map = {
            \ '__' : '-',
            \ 'n' : '',
            \ 'i' : '',
            \ 'R' : '',
            \ 'c' : '',
            \ 'v' : '',
            \ 'V' : '',
            \ '' : '',
            \ }

"-------------MY PATHS SHORTCUT------------

let myPathsOpts={ "title": "Edit.." }
let myPaths=[]
call add(myPaths,['Notes (&n)','vsp $HOME/.vim/notes'])
call add(myPaths,['Helps (&h)','vsp $HOME/.vim/notes/vimhelp.md'])
call add(myPaths,['-'])

if exists('g:neovide') || has('nvim')
  call add(myPaths,['Vimrc (&v)','vsp $HOME/.vimrc'])
  call add(myPaths,['NVim (&e)','vsp $MYVIMRC'])
else
  call add(myPaths,['Vimrc (&v)','vsp $MYVIMRC'])
endif

call add(myPaths,['General (&g)','vsp $HOME/.vim/general.vim'])
call add(myPaths,['Plugin (&p)','vsp $HOME/.vim/plugins.vim'])
call add(myPaths,['-'])

call add(myPaths,['Zshrc (&z)','vsp $HOME/.zshrc'])
call add(myPaths,['Zsh Plugin (&l)','vsp $HOME/.vim/plugins.zsh'])
call add(myPaths,['-'])

call add(myPaths,['Install.sh (&i)','vsp $HOME/.vim/install.sh'])
call add(myPaths,['-'])

call add(myPaths,['/Home (&d)','vsp $HOME/.vim'])
call add(myPaths,['/Code (&c)','vsp $HOME/code'])
noremap <nowait><silent><leader>e :call quickui#context#open(myPaths, myPathsOpts)<cr>

nmap <silent><leader>pi :PlugInstall<cr>
nmap <silent><leader>pu :PlugUpdate<cr>

let g:utilOpts = {'title': 'Utility Menu'}
let g:utilContent = []

call add(g:utilContent, [ 'Minimap Toggle (&m)', 'MinimapToggle' ])
call add(g:utilContent, [ 'NPM Run (&n)', 'call NpmRun()' ])
call add(g:utilContent, ['-'])

call add(g:utilContent, [ 'Generate GUID (&i)', 'call GenerateGUID()' ])
call add(g:utilContent, [ 'Delete all white spaces (&w)', '%s/^$\\|^\s\+//g' ])
call add(g:utilContent, ['-'])

"-------------------------------------------

"iamcco/markdown-preview.nvim
let g:mkdp_auto_start = 0
call add(g:utilContent, [ 'Markdown Preview (&d)', 'MarkdownPreview' ])
call add(g:utilContent, ['-'])

call add(g:utilContent, [ 'Clear Registers (&x)', 'call ClearReg()' ])

noremap <silent><nowait><leader>m :call quickui#context#open(g:utilContent, g:utilOpts)<cr>

"-------------PLUGINS------------

"skywind3000/vim-quickui-------------------
let g:quickui_border_style = 2
let g:quickui_color_scheme = 'gruvbox'
nnoremap <silent><nowait><leader>b :call quickui#tools#list_buffer('e')<cr>

"skywind3000/asyncrun.vim
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

"TaDaa/vimade
let g:vimade = {}
let g:vimade.fadelevel = 0.5

"airblade/vim-rooter
let g:rooter_silent_chdir = 1
let g:rooter_patterns = ['.git', 'package.json', '*.sln', 'appsettings.json', '*.csproj']
let g:rooter_change_directory_for_non_project_files = 'home'

"Asheq/close-buffers.vim
nnoremap <Leader>q :Bdelete menu<CR>

"mbbill/undotree
nnoremap <leader>u :UndotreeToggle<cr>
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 3

"mattn/emmet-vim
let g:user_emmet_settings = {
            \  'javascript' : {
                \      'extends' :['jsx','tsx'],
                \  },
                \}

"gabrielelana/vim-markdown
let g:markdown_enable_mappings = 1
let g:markdown_enable_spell_checking = 0
let g:markdown_enable_conceal = 1
let g:markdown_enable_folding = 1
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_fenced_languages = ['js=javascript', 'jsx=javascriptreact', 'ts=typescript', 'tsx=typescriptreact', 'sh=bash', 'cs=csharp']

"HerringtonDarkholme/yats.vim
let g:typescript_conceal_function             = "ƒ"
let g:typescript_conceal_null                 = "ø"
let g:typescript_conceal_undefined            = "¿"
let g:typescript_conceal_this                 = "@"
let g:typescript_conceal_return               = "⇚"
let g:typescript_conceal_prototype            = "¶"
let g:typescript_conceal_super                = "Ω"

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
call add(concealMenu, ['Toggle TS Conceal(&t)', 'exec &conceallevel ? "set conceallevel=0" : "set conceallevel=1"'])
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

"MattesGroeger/vim-bookmarks
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
hi BookmarkSign ctermbg=NONE ctermfg=red guibg=NONE guifg=red
hi BookmarkLine ctermbg=NONE ctermfg=NONE guibg=#343434 guifg=NONE

"dominikduda/vim_current_word
let g:vim_current_word#highlight_current_word = 1
let g:vim_current_word#highlight_twins = 1
hi CurrentWord gui=bold,underline cterm=bold,underline
hi CurrentWordTwins gui=bold cterm=bold

"andrewradev/tagalong.vim
"let g:tagalong_additional_filetypes = []
let g:tagalong_verbose = 1

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

"machakann/vim-sandwich
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
let g:sandwich#recipes += [
      \{'buns': ['{\s*', '\s*}'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['{']},
      \{'buns': ['\[\s*', '\s*\]'], 'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['[']},
      \{'buns': ['(\s*', '\s*)'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['(']},
      \ ]

xmap is <Plug>(textobj-sandwich-auto-i)
xmap as <Plug>(textobj-sandwich-auto-a)
omap is <Plug>(textobj-sandwich-auto-i)
omap as <Plug>(textobj-sandwich-auto-a)
hi OperatorSandwichChange ctermfg=109 ctermbg=237 guifg=#83a598 guibg=#3c3836
hi OperatorSandwichAdd cterm=bold ctermfg=10 gui=bold guifg=#7fbf00
hi OperatorSandwichDelete cterm=bold ctermfg=10 gui=bold guifg=#fb4934

"easymotion/vim-easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
nmap F <Plug>(easymotion-overwin-f2)
hi link EasyMotionTarget IncSearch
hi link EasyMotionShade Comment
hi link EasyMotionTarget2First MatchParen
hi link EasyMotionTarget2Second MatchParen
hi link EasyMotionMoveHL Search
hi link EasyMotionIncSearch IncSearch

"tpope/vim-fugitive / idanarye/vim-merginal / junegunn/gv.vim
nnoremap <silent> <Leader>1 :Git<cr><c-w>T
nnoremap <silent> <Leader>2 :GV --all<cr>
vnoremap <silent> <Leader>2 :GV!<cr>
nnoremap <silent> <Leader>3 :ToggleMerginal<cr>
nnoremap <silent> <Leader>gc :Git commit<cr>
nnoremap <silent> <Leader>gr :Gread<cr>
nnoremap <silent> <Leader>gw :Gwrite<cr>
nnoremap <silent> <Leader>gd :Gdiff<cr>
nnoremap <silent> <Leader>gD :Gdiffsplit!<cr>
nnoremap <Leader>ge :Gedit<cr>
nnoremap <silent> <Leader>gb :Git blame<cr>
nnoremap <silent> <Leader>gp :AsyncRun git -c push.default=current push<cr>
nnoremap <silent> <Leader>gP :AsyncRun git push -f<cr>
nnoremap <silent> <Leader>gl :AsyncRun git pull<cr>
nnoremap <silent><Leader>gfo :AsyncRun git fetch origin
nnoremap <silent><Leader>gfa :AsyncRun git fetch --all --prune<cr>
nnoremap <silent> <Leader>gof :Gbrowse<cr>

command! ToggleMerginal execute len(FugitiveHead()) > 0 ? ':MerginalToggle' : 'echoerr "Not in a git repo"'
if has("autocmd")
    autocmd BufReadPost fugitive://* set bufhidden=delete
endif

"tyru/open-browser.vim, tyru/open-browser-github.vim
let gitOpt = {'title':'GITHUB Menu'}
let githubMenu = []
call add(githubMenu , ['Open PR (&r)', 'exec "OpenGithubPullReq #" . FugitiveHead()'])
call add(githubMenu , ['Open current file (&f)', 'Gbrowse'])
call add(githubMenu , ['Open project (&g)', 'OpenGithubProect'])
call add(githubMenu , ['Open issues (&i)', 'OpenGithubIssue'])
call add(githubMenu , ['Open pull requests (&p)', 'OpenGithubPullReq'])
noremap <silent><nowait><leader>go :call quickui#context#open(githubMenu, gitOpt)<cr>

"junegunn/fzf
set rtp+=~/.fzf
let $FZF_DEFAULT_OPTS="--layout=reverse --bind ctrl-k:preview-up,ctrl-j:preview-down"
let $FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{node_modules/*,.git/*}"'
let g:fzf_layout={'window':{ 'width': 0.9, 'height': 0.6 }}
let g:fzf_preview_window = ['right:60%:hidden','?']
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-o': 'split',
            \ 'ctrl-v': 'vsplit' }
command! Ctrlp execute len(FugitiveHead()) > 0 ? ':GFiles' : ':Files'
nnoremap <silent> <C-p> :Ctrlp<CR>
nnoremap <silent> <C-e> :History<CR>
nnoremap <Leader>f :Rg<space>
vnoremap <Leader>f y:Rg <c-r>"<cr>
nnoremap <Leader>F :Rg <c-r><c-w><cr>
nnoremap <Leader>@ :BCommits<cr>

autocmd! FileType fzf
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

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
      \ 'coc-csharp-ls',
      \ 'coc-eslint',
      \ 'coc-snippets',
      \ 'coc-kotlin'
      \]

nmap <silent><nowait>gh <Plug>(coc-diagnostic-info)
nmap <silent><nowait>gd <Plug>(coc-definition)
nmap <silent><nowait>gy <Plug>(coc-type-definition)
nmap <silent><nowait>gi <Plug>(coc-implementation)
nmap <silent><nowait>gr <Plug>(coc-references)
nmap <silent><nowait><S-r> <Plug>(coc-rename)
nmap <silent><nowait><leader><S-r> :CocCommand workspace.renameCurrentFile<cr>
xmap <nowait><leader>= <Plug>(coc-format-selected)
nmap <nowait><leader>= <Plug>(coc-format)
xmap <nowait><leader>ac <Plug>(coc-codeaction-selected)
nmap <nowait><leader>ac <Plug>(coc-codeaction-selected)
nmap <nowait><leader>ap <Plug>(coc-diagnostic-prev)
nmap <nowait><leader>an <Plug>(coc-diagnostic-next)
nmap <nowait><leader>. <Plug>(coc-codeaction)
nmap <nowait><leader>. <Plug>(coc-fix-current)
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
command! -nargs=0 Format         :call CocActionAsync('format')
command! -nargs=? Fold           :call CocActionAsync('fold', <f-args>)
command! -nargs=0 OrganizeImport :call CocActionAsync('runCommand', 'editor.action.organizeImport')
command! -nargs=0 RenameFile :CocCommand workspace.renameCurrentFile
command! -nargs=0 CocUndo :CocCommand workspace.undo
command! -nargs=0 CocRedo :CocCommand workspace.redo

inoremap <silent><expr> <TAB>
  \ coc#pum#visible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ?
  \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

augroup cocOverride
  autocmd!
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  "Javascript formatSelected
  autocmd FileType javasccript,javascriptreact,typescript,typescriptreact,json setl formatexpr=CocActionAsync('formatSelected')
  "Disable markdown suggestions
  autocmd FileType markdown let b:coc_suggest_disable = 1

  "C# overrides
  autocmd FileType cs nmap <silent><buffer><C-b> :AsyncRun dotnet build<cr>
  function! s:create_dotnet_controller() abort
    let controllerName = input('Controller Name: ')
    let modelName = input('Model Name: ')
    let dbContextName = input('DB Context Name: ')
    if controllerName != "" && modelName != "" && dbContextName != ""
      let script = ":!dotnet aspnet-codegenerator controller "
            \.. "-name " .. controllerName .. "Controller "
            \.. "-async "
            \.. "-api "
            \.. "-m " .. modelName .. " "
            \.. "-dc " .. dbContextName .. " "
            \.. "-outDir Controllers"
      exe script
    else
      echo "Cancelled"
    endif
  endfunction
  command! CreateController call s:create_dotnet_controller()
augroup end

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

"--------Testing vim-test/vim-test--------"
function! TestNearestJS(runner, ...)
  let g:test#javascript#runner = a:runner
  execute ":TestNearest " .. a:1
  unlet g:test#javascript#runner
endfunction
function! TestLastJS(runner, ...)
  let g:test#javascript#runner = a:runner
  execute ":TestLast " .. a:1
  unlet g:test#javascript#runner
endfunction
function! TestFileJS(runner, ...)
  let g:test#javascript#runner = a:runner
  execute ":TestFile " .. a:1
  unlet g:test#javascript#runner
endfunction
function! TestSuiteJS(runner, ...)
  let g:test#javascript#runner = a:runner
  execute ":TestSuite " .. a:1
  unlet g:test#javascript#runner
endfunction

function! OpenTestMenu(title, name, args)
  let testPopupOpt = {'title': a:title .. ' Test'}
  let testPopupMenu = [
        \ [ 'Test this (&t)'  , "call TestNearestJS('" .. a:name .. "', '" .. a:args .. "')" ] ,
        \ [ 'Test file (&f)'  , "call TestFileJS('" .. a:name .. "', '" .. a:args .. "')" ]    ,
        \ [ 'Test suite (&s)' , "call TestSuiteJS('" .. a:name .. "', '" .. a:args .. "')" ]   ,
        \ [ 'Test last (&l)'  , "call TestLastJS('" .. a:name .. "', '" .. a:args .. "')" ]    ,
        \]
  if(a:title == 'Jest')
    call add(testPopupMenu, [ 'Cypress(&o)', "OpenCypressMenu" ])
    call add(testPopupMenu, [ 'Playwright(&p)', "OpenPlaywrightMenu" ])
  endif
  call quickui#listbox#open(testPopupMenu, testPopupOpt)
endfunction

command! OpenJestMenu call OpenTestMenu('Jest', 'jest', '--update-snapshot')
command! OpenCypressMenu call OpenTestMenu('Cypress', 'cypress', '-C ./cypress/cypress.json')
command! OpenPlaywrightMenu call OpenTestMenu('Playwright', 'jest', '--config ./jest-playwright.config.js')
command! OpenCSharpTestMenu call OpenTestMenu('XUnit Test', 'xunit', '--nologo -v=q')

map <silent><nowait><leader>t :OpenJestMenu<cr>
autocmd FileType cs map <silent><nowait><leader>t :OpenCSharpTest<cr>

if exists('g:neovide') || has('nvim')
  let test#strategy='neovim'
else
  let test#strategy='asyncrun_background_term'
endif
let g:test#basic#start_normal = 1
let g:test#neovim#start_normal = 1
let g:test#echo_command = 0
let g:test#runner_commands= ["Jest", "Cypress", "Playwright", "DotnetTest"]

"nicwest/vim-http
let g:vim_http_clean_before_do=0
let g:vim_http_split_vertically=1
let g:vim_http_tempbuffer=1
let g:vim_http_additional_curl_args='-k'

function! s:set_json_header() abort
  call http#set_header('Content-Type', 'application/json')
endfunction

function! s:clean_personal_stuff() abort
  call http#remove_header('Cookie')
  call http#remove_header('Accept')
  call http#remove_header('User-Agent')
  call http#remove_header('Accept-Language')
endfunction

function! s:add_compression() abort
  call http#set_header('Accept-Encoding', 'deflate, gzip')
  let g:vim_http_additional_curl_args = '--compressed'
endfunction

command! JSON call s:set_json_header()
command! Anon call s:clean_personal_stuff()
command! Compression call s:add_compression()

"--------HIGHLIGHT OVERRIDE------

augroup WhitespaceMatch
  autocmd!
  function! s:ToggleWhitespaceMatch(mode)
    let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
    if exists('w:whitespace_match_number')
      call matchdelete(w:whitespace_match_number)
      call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
    else
      let w:whitespace_match_number = matchadd('ExtraWhitespace', pattern)
    endif
  endfunction

  autocmd BufWinEnter * let w:whitespace_match_number = matchadd('ExtraWhitespace', '\s\+$')
  autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
augroup END
hi ExtraWhitespace ctermbg=red guibg=red

hi LineNr ctermbg=0 guibg=bg
hi vertsplit ctermbg=0 guibg=bg
hi foldcolumn ctermbg=0 guibg=bg guifg=white
hi SignColumn guibg=bg
hi Comment cterm=NONE
hi diffAdded ctermfg=142 guifg=#a9b665
hi diffRemoved ctermfg=167 guifg=#ea6962

hi Search ctermfg=black ctermbg=white guifg=black guibg=white
hi CurSearch cterm=reverse,bold gui=reverse,bold

"-----AUTO-COMMANDS------"
augroup autosourcing
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    autocmd BufWritePost $HOME/.vim/general.vim source $MYVIMRC
    autocmd BufWritePost $HOME/.vim/plugins.vim source $MYVIMRC

    autocmd BufWritePost $MYVIMRC AirlineRefresh
    autocmd BufWritePost $HOME/.vim/general.vim AirlineRefresh
    autocmd BufWritePost $HOME/.vim/plugins.vim AirlineRefresh

    au BufNewFile,BufRead *.ejs set filetype=js
    au BufNewFile,BufRead *.vue,*.hbs set filetype=html
    au BufNewFile,BufRead *.jsx set filetype=javascriptreact
    au BufNewFile,BufRead *.tsx set filetype=typescriptreact
augroup END

