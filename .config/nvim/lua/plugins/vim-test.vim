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

func! PopupTestMenu(title, name, args)
  let testPopupOpt = {'title': a:title .. ' Test'}
  let testPopupMenu = [
        \ [ 'Test this (&t)'  , "call TestNearestTest('" .. a:name .. "', '" .. a:args .. "')" ] ,
        \ [ 'Test file (&f)'  , "call TestThisFile('" .. a:name .. "', '" .. a:args .. "')" ]    ,
        \ [ 'Test suite (&s)' , "call TestThisSuite('" .. a:name .. "', '" .. a:args .. "')" ]   ,
        \ [ 'Test last (&l)'  , "call TestLastRan('" .. a:name .. "', '" .. a:args .. "')" ]    ,
        \]
  if(a:title == 'Jest')
    call add(testPopupMenu, [ 'Cypress(&o)', "PopupCypressMenu" ])
    call add(testPopupMenu, [ 'Playwright(&p)', "PopupPlaywrightMenu" ])
  endif
  call quickui#listbox#open(testPopupMenu, testPopupOpt)
endfunc

command! PopupJestMenu call PopupTestMenu('Jest', 'jest', '--update-snapshot')
command! PopupCypressMenu call PopupTestMenu('Cypress', 'cypress', '-C ./cypress/cypress.json')
command! PopupPlaywrightMenu call PopupTestMenu('Playwright', 'jest', '--config ./jest-playwright.config.js')
command! PopupCSharpTestMenu call PopupTestMenu('XUnit Test', 'xunit', '--nologo -v=q')
command! PopupDartTestMenu call PopupTestMenu('Dart Test', 'fluttertest', '')

autocmd FileType javasccript,javascriptreact,typescript,typescriptreact nmap <silent><nowait><buffer><leader>t :PopupJestMenu<cr>

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
autocmd FileType cs nmap <silent><nowait><buffer><leader>t :PopupCSharpTestMenu<cr>
autocmd FileType cs nmap <silent><nowait><buffer><C-b> :AsyncRun dotnet build<cr>

"Dart overrides
autocmd FileType dart nmap<silent><nowait><buffer><leader>t :PopupDartTestMenu<cr>
