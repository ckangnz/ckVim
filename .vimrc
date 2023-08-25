so ~/.vim/extra_vim_config/general.vim                           "General Vim settings
so ~/.vim/extra_vim_config/plugins.vim                           "Source the plugins
so ~/.vim/extra_vim_config/coc.vim                               "Source the coc settings
runtime macros/sandwich/keymap/surround.vim

filetype plugin indent on
:filetype indent on

"*-*-*-*-*-*-THEMES-*-*-*-*-*-*
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
let g:airline_left_sep = "\ue0d2"
let g:airline_right_sep = ''
let g:airline_section_y = airline#section#create(["%{coc#status()}%{get(b:,'coc_current_function','')}"])
let g:airline_section_z = airline#section#create(['%{g:airline_symbols.linenr}%#__accent_bold#%3l/%3L', '%{g:airline_symbols.colnr}%#__accent_bold#%3v'])
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#left_sep="\uE0C4"
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let airline#extensions#tabline#tabs_label = ''
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

"*-*-*-*-*-*-MY PATH MENU-*-*-*-*-*-*
let myPathsOpts={ "title": "My Paths" }

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

call add(myPaths,['-'])
call add(myPaths,['\~/.vim (&d)','vsp $HOME/.vim'])
call add(myPaths,['Readme.md (&r)','vsp $HOME/.vim/README.md'])
call add(myPaths,['Install.sh (&i)','vsp $HOME/.vim/install.sh'])

call add(myPaths,['-'])
call add(myPaths,['General (&g)','vsp $HOME/.vim/extra_vim_config/general.vim'])
call add(myPaths,['Plugin (&p)','vsp $HOME/.vim/extra_vim_config/plugins.vim'])
call add(myPaths,['Coc Settings (&c)','vsp $HOME/.vim/extra_vim_config/coc.vim'])

call add(myPaths,['-'])
call add(myPaths,['Zshrc (&z)','vsp $HOME/.zshrc'])
call add(myPaths,['Zsh Plugin (&l)','vsp $HOME/.vim/plugins.zsh'])

noremap <nowait><silent><leader>e :call quickui#context#open(myPaths, myPathsOpts)<cr>

nmap <silent><leader>pi :PlugInstall<cr>
nmap <silent><leader>pu :PlugUpdate<cr>

"*-*-*-*-*-*-MY UTILITY MENU-*-*-*-*-*-*
let g:utilOpts = {'title': 'Utility Menu'}
let g:utilContent = []

call add(g:utilContent, [ 'Generate GUID (&i)', 'call GenerateGUID()' ])
call add(g:utilContent, [ 'Delete all white spaces (&w)', '%s/^$\\|^\s\+//g' ])
call add(g:utilContent, ['-'])

"----MARKDOWN PREVIEW: iamcco/markdown-preview.nvim
let g:mkdp_auto_start = 0
call add(g:utilContent, [ 'Markdown Preview (&d)', 'MarkdownPreview' ])
call add(g:utilContent, ['-'])

call add(g:utilContent, [ 'Clear Registers (&x)', 'call ClearReg()' ])

noremap <silent><nowait><leader>m :call quickui#context#open(g:utilContent, g:utilOpts)<cr>

"*-*-*-*-*-*-LANGUAGE PLUGINS-*-*-*-*-*-*
"----EMMET: mattn/emmet-vim
let g:user_emmet_settings = {
      \  'javascript' : {
      \      'extends' :['jsx','tsx'],
      \  },
      \}

"----------HTML TAG PAIRS: andrewradev/tagalong.vim
"let g:tagalong_additional_filetypes = []
let g:tagalong_verbose = 1

"----TYPESCRIPT ALIAS: HerringtonDarkholme/yats.vim
let g:typescript_conceal_function             = "ƒ"
let g:typescript_conceal_null                 = "ø"
let g:typescript_conceal_undefined            = "¿"
let g:typescript_conceal_this                 = "@"
let g:typescript_conceal_return               = "⇚"
let g:typescript_conceal_prototype            = "¶"
let g:typescript_conceal_super                = "Ω"

"----MARKDOWN: gabrielelana/vim-markdown
let g:markdown_enable_mappings = 1
let g:markdown_enable_spell_checking = 0
let g:markdown_enable_conceal = 1
let g:markdown_enable_folding = 1
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_fenced_languages = ['js=javascript', 'jsx=javascriptreact', 'ts=typescript', 'tsx=typescriptreact', 'sh=bash', 'cs=csharp']


"*-*-*-*-*-*-VISUAL PLUGINS-*-*-*-*-*-*
"----FADE INACTIVE PANEL: TaDaa/vimade
let g:vimade = {}
let g:vimade.fadelevel = 0.5

"----QUICK-UI: skywind3000/vim-quickui
let g:quickui_border_style = 2
let g:quickui_color_scheme = 'gruvbox'
nnoremap <silent><nowait><leader>b :call quickui#tools#list_buffer('e')<cr>

"----HIGHLIGHT CURRENT WORD: dominikduda/vim_current_word
let g:vim_current_word#highlight_current_word = 1
let g:vim_current_word#highlight_twins = 1
hi CurrentWord gui=bold,underline cterm=bold,underline
hi CurrentWordTwins gui=bold cterm=bold

"----HIGHLIGHT CURRENT LINE: miyakogi/conoline.vim
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

"----INDENTATION BAR: Yggdroot/indentLine
map <silent> <Leader>ll :IndentLinesToggle<cr>
let g:indentLine_enabled = 0
let g:indentLine_setColors = 1
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_char_list = ['┊','|', '¦', '┆']
let g:indentLine_defaultGroup = 'SpecialKey'
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2


"*-*-*-*-*-*-FUNCTIONALITY PLUGINS-*-*-*-*-*-*
"---------ASYNCRUN: skywind3000/asyncrun.vim
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

"---------CLOSE BUFFERS: Asheq/close-buffers.vim
nnoremap <Leader>q :Bdelete menu<CR>

"---------VIM-ROOTER: airblade/vim-rooter
let g:rooter_silent_chdir = 1
let g:rooter_patterns = ['.git', 'package.json', '*.sln', 'appsettings.json']
let g:rooter_change_directory_for_non_project_files = 'home'

"---------UNDO TREE: mbbill/undotree
nnoremap <leader>u :UndotreeToggle<cr>
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 3

"---------DOCKER: kkvh/vim-docker-tools
nnoremap <silent><leader>dc :DockerToolsToggle<cr>

"---------DATABASE: tpope/vim-dadbod
" postgres://postgres:mypassword@localhost:5432/my-dev-db
" mysql://root@localhost/wp_awesome
" jdbc:sqlserver://localhost:1433;property=value;
nnoremap <silent><leader>db :DBUI<cr>

"---------TABULAR: godlygeek/tabular
nmap <Leader>T :Tabularize/
vmap <Leader>T :Tabularize/
inoremap <silent> <Bar> <Bar><Esc>:call <SID>align()<CR>a
func! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunc

"---------HTTP RESTFUL CALLS: nicwest/vim-http
let g:vim_http_clean_before_do=0
let g:vim_http_split_vertically=1
let g:vim_http_tempbuffer=1
let g:vim_http_additional_curl_args='-k'
func! s:set_json_header() abort
  call http#set_header('Content-Type', 'application/json')
endfunc
func! s:clean_personal_stuff() abort
  call http#remove_header('Cookie')
  call http#remove_header('Accept')
  call http#remove_header('User-Agent')
  call http#remove_header('Accept-Language')
endfunc
func! s:add_compression() abort
  call http#set_header('Accept-Encoding', 'deflate, gzip')
  let g:vim_http_additional_curl_args = '--compressed'
endfunc
command! JSON call s:set_json_header()
command! Anon call s:clean_personal_stuff()
command! Compression call s:add_compression()

"----------EASYMOTION: easymotion/vim-easymotion
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

"----------SANDWICH: machakann/vim-sandwich
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

"---------BOOKMARKS: MattesGroeger/vim-bookmarks
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

"---------BROWSERS: tyru/open-browser.vim, tyru/open-browser-github.vim
let gitOpt = {'title':'GITHUB Menu'}
let githubMenu = []
call add(githubMenu , ['Open PR (&r)', 'exec "OpenGithubPullReq #" . FugitiveHead()'])
call add(githubMenu , ['Open current file (&f)', 'Gbrowse'])
call add(githubMenu , ['Open project (&g)', 'OpenGithubProect'])
call add(githubMenu , ['Open issues (&i)', 'OpenGithubIssue'])
call add(githubMenu , ['Open pull requests (&p)', 'OpenGithubPullReq'])
noremap <silent><nowait><leader>go :call quickui#context#open(githubMenu, gitOpt)<cr>

"--------GIT: tpope/vim-fugitive / idanarye/vim-merginal / junegunn/gv.vim
nnoremap <silent> <Leader>1 :Git<cr><c-w>T
nnoremap <silent> <Leader>2 :GV --all<cr>
vnoremap <silent> <Leader>2 :GV!<cr>
nnoremap <silent> <Leader>3 :execute len(FugitiveHead()) > 0 ? ':MerginalToggle' : 'echoerr "Not in a git repo"'<cr>
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

func s:UpdateGitStatusLine() abort
  if !exists('*FugitiveExtractGitDir')
    return ''
  endif
  let dir = exists('b:git_dir') ? b:git_dir : FugitiveExtractGitDir(resolve(expand('%:p')))
  if empty(dir)
    return ''
  endif
  let b:git_dir = dir
endfunc

if has("autocmd")
  autocmd BufReadPost fugitive://* set bufhidden=delete
  au BufWinEnter,ShellCmdPost,BufWritePost * call s:UpdateGitStatusLine()
endif

"----FZF FINDER: junegunn/fzf
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

"--------Testing: vim-test/vim-test
func! TestNearestTest(runner, ...)
  let g:test#javascript#runner = a:runner
  execute ":TestNearest " .. a:1
  unlet g:test#javascript#runner
endfunc
func! TestLastRan(runner, ...)
  let g:test#javascript#runner = a:runner
  execute ":TestLast " .. a:1
  unlet g:test#javascript#runner
endfunc
func! TestThisFile(runner, ...)
  let g:test#javascript#runner = a:runner
  execute ":TestFile " .. a:1
  unlet g:test#javascript#runner
endfunc
func! TestThisSuite(runner, ...)
  let g:test#javascript#runner = a:runner
  execute ":TestSuite " .. a:1
  unlet g:test#javascript#runner
endfunc

func! OpenTestMenu(title, name, args)
  let testPopupOpt = {'title': a:title .. ' Test'}
  let testPopupMenu = [
        \ [ 'Test this (&t)'  , "call TestNearestTest('" .. a:name .. "', '" .. a:args .. "')" ] ,
        \ [ 'Test file (&f)'  , "call TestThisFile('" .. a:name .. "', '" .. a:args .. "')" ]    ,
        \ [ 'Test suite (&s)' , "call TestThisSuite('" .. a:name .. "', '" .. a:args .. "')" ]   ,
        \ [ 'Test last (&l)'  , "call TestLastRan('" .. a:name .. "', '" .. a:args .. "')" ]    ,
        \]
  if(a:title == 'Jest')
    call add(testPopupMenu, [ 'Cypress(&o)', "OpenCypressMenu" ])
    call add(testPopupMenu, [ 'Playwright(&p)', "OpenPlaywrightMenu" ])
  endif
  call quickui#listbox#open(testPopupMenu, testPopupOpt)
endfunc

command! OpenJestMenu call OpenTestMenu('Jest', 'jest', '--update-snapshot')
command! OpenCypressMenu call OpenTestMenu('Cypress', 'cypress', '-C ./cypress/cypress.json')
command! OpenPlaywrightMenu call OpenTestMenu('Playwright', 'jest', '--config ./jest-playwright.config.js')
command! OpenCSharpTestMenu call OpenTestMenu('XUnit Test', 'xunit', '--nologo -v=q')
command! OpenDartTestMenu call OpenTestMenu('Dart Test', 'fluttertest', '')

map <silent><nowait><leader>t :OpenJestMenu<cr>

if exists('g:neovide') || has('nvim')
  let test#strategy='neovim'
else
  let test#strategy='asyncrun_background_term'
endif
let g:test#basic#start_normal = 1
let g:test#neovim#start_normal = 1
let g:test#echo_command = 0
let g:test#runner_commands= ["Jest", "Cypress", "Playwright", "DotnetTest"]

"CSharp overrides
autocmd FileType cs map <silent><nowait><leader>t :OpenCSharpTestMenu<cr>
autocmd FileType cs nmap <silent><buffer><C-b> :AsyncRun dotnet build<cr>

"SCSS override
autocmd FileType scss setl iskeyword+=@-@

"Dart overrides
autocmd FileType dart nmap<silent><leader>t :OpenDartTestMenu<cr>
"-----------------------------------------


"*-*-*-*-*-*-HIGHLIGHT OVERRIDE-*-*-*-*-*-*
augroup WhitespaceMatch
  autocmd!
  func! s:ToggleWhitespaceMatch(mode)
    let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
    if exists('w:whitespace_match_number')
      call matchdelete(w:whitespace_match_number)
      call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
    else
      let w:whitespace_match_number = matchadd('ExtraWhitespace', pattern)
    endif
  endfunc

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

"*-*-*-*-*-*-AUTO COMMANDS-*-*-*-*-*-*
augroup autosourcing
  au!
  if exists('g:neovide') || has('nvim')
    au BufWritePost $HOME/.vimrc source $MYVIMRC
    au BufWritePost $HOME/.vimrc AirlineRefresh
  endif

  au BufWritePost $MYVIMRC source $MYVIMRC
  au BufWritePost $HOME/.vim/extra_vim_config/general.vim source $MYVIMRC
  au BufWritePost $HOME/.vim/extra_vim_config/plugins.vim source $MYVIMRC
  au BufWritePost $HOME/.vim/extra_vim_config/coc.vim source $MYVIMRC

  au BufWritePost $MYVIMRC AirlineRefresh
  au BufWritePost $HOME/.vim/extra_vim_config/general.vim AirlineRefresh
  au BufWritePost $HOME/.vim/extra_vim_config/plugins.vim AirlineRefresh
  au BufWritePost $HOME/.vim/extra_vim_config/coc.vim AirlineRefresh

  au BufNewFile,BufRead *.ejs set filetype=js
  au BufNewFile,BufRead *.vue,*.hbs set filetype=html
  au BufNewFile,BufRead *.jsx set filetype=javascriptreact
  au BufNewFile,BufRead *.tsx set filetype=typescriptreact
augroup END

