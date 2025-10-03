vim.g['test#strategy'] = 'neovim'
vim.g['test#preserve_screen'] = 1
vim.g['test#basic#start_normal'] = 1
vim.g['test#neovim#start_normal'] = 1
vim.g['test#echo_command'] = 0
vim.g['test#runner_commands'] = {
  'Jest',
  'Vitest',
  'Cypress',
  'Playwright',
  'DotnetTest',
  'Xunit',
  'FlutterTest',
}
vim.g['test#enabled_runners'] = {
  'javascript#jest',
  'javascript#vitest',
  'javascript#cypress',
  'javascript#playwright',
  'csharp#dotnettest',
  'csharp#xunit',
  'dart#fluttertest',
}

-- JavaScript test configuration
vim.g['test#javascript#jest#options'] = '--update-snapshot'
vim.g['test#javascript#cypress#options'] = '--config ./cypress/cypress.json'
vim.g['test#javascript#playwright#options'] = '--config ./jest-playwright.config.js'

-- C# test configuration
vim.g['test#csharp#runner'] = 'dotnettest'
vim.g['test#csharp#dotnettest#options'] =
  '--nologo -v=q -l:"console;verbosity=minimal;consoleloggerparameters=ErrorsOnly" '

-- Keymaps
vim.keymap.set('n', ',tt', ':TestNearest<cr>', {
  desc = 'Test nearest',
  silent = true,
  nowait = true,
})

vim.keymap.set('n', ',tf', ':TestFile<cr>', {
  desc = 'Test file',
  silent = true,
  nowait = true,
})

vim.keymap.set('n', ',ts', ':TestSuite<cr>', {
  desc = 'Test suite',
  silent = true,
  nowait = true,
})

vim.keymap.set('n', ',tl', ':TestLast<cr>', {
  desc = 'Test last',
  silent = true,
  nowait = true,
})

-- C# specific keymaps
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cs',
  callback = function()
    vim.keymap.set('n', '<C-b>', ':AsyncRun dotnet build<cr>', {
      desc = 'Build .NET project',
      buffer = true,
      silent = true,
      nowait = true,
    })
  end,
})
