vim.g.codeium_enabled = true
vim.g.codeium_disable_bindings = true -- We'll define our own keymaps
vim.g.codeium_no_map_tab = true -- Don't map Tab key
vim.g.codeium_render = true -- Enable rendering
vim.g.codeium_manual = true -- Manual trigger mode
vim.g.codeium_tab_fallback = '\t' -- Fallback for Tab key

-- Codeium keymaps
vim.api.nvim_create_user_command('ToggleCodeium', function()
  if vim.g.codeium_enabled == 0 then
    vim.cmd('Codeium Enable')
  else
    vim.cmd('Codeium Disable')
  end
end, { desc = 'Toggle Codeium' })
vim.keymap.set('n', '<leader>cT', ':ToggleCodeium<CR>', { desc = 'Toggle Codeium' })

vim.keymap.set('i', '<M-[>', function()
  return vim.fn['codeium#CycleCompletions'](-1)
end, { expr = true, silent = true, desc = 'Previous Codeium suggestion' })
vim.keymap.set('i', '<M-]>', function()
  return vim.fn['codeium#CycleOrComplete']()
end, { expr = true, silent = true, desc = 'Next Codeium suggestion or complete' })
vim.keymap.set('i', '<M-x>', function()
  return vim.fn['codeium#Clear']()
end, { expr = true, silent = true, desc = 'Clear Codeium suggestions' })
-- Refer to keymaps.lua for codeium#accept <M-a>

vim.g.codeium_filetypes = {
  ['codecompanion'] = false,
  ['fugitive'] = false,
  ['markdown'] = false,
  ['help'] = false,
  ['hgcommit'] = false,
  ['svn'] = false,
  ['cvs'] = false,
  ['.'] = false,
}
