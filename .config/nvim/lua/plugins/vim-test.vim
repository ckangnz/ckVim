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

"Dart overrides
autocmd FileType dart nmap<silent><leader>t :OpenDartTestMenu<cr>
