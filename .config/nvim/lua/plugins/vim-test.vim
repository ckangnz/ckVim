"--------Testing: vim-test/vim-test
func! PopupTestMenu()
  let testPopupOpt = {'title': 'Run Tests'}
  let testPopupMenu = [
        \ [ 'Test this (&t)'  , "TestNearest" ],
        \ [ 'Test file (&f)'  , "TestFile" ],
        \ [ 'Test suite (&s)' , "TestSuite" ],
        \ [ 'Test last (&l)'  , "TestLast" ],
        \]
  call quickui#listbox#open(testPopupMenu, testPopupOpt)
endfunc
command! PopupTestMenu call PopupTestMenu()

autocmd FileType * nmap <silent><nowait><buffer><leader>t :PopupTestMenu<cr>

if exists('g:neovide') || has('nvim')
  let test#strategy='neovim'
else
  let test#strategy='asyncrun_background_term'
endif

let g:test#preserve_screen = 1
let g:test#basic#start_normal = 1
let g:test#neovim#start_normal = 1
let g:test#echo_command = 0
let g:test#runner_commands= ["Jest", "Cypress", "Playwright", "DotnetTest", "Xunit", "FlutterTest"]

"Javascript Configs
let test#javascript#jest#options='--update-snapshot'
let test#javascript#cypress#options='--config ./cypress/cypress.json'
let test#javascript#playwright#options='--config ./jest-playwright.config.js'

"CSharp Configs
let test#csharp#runner = 'dotnettest'
let test#csharp#dotnettest#options = '--nologo -v=q -l:"console;verbosity=minimal;consoleloggerparameters=ErrorsOnly" '

"CSharp overrides
autocmd FileType cs nmap <silent><nowait><buffer><C-b> :AsyncRun dotnet build<cr>
