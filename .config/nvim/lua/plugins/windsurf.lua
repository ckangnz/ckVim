vim.g.codeium_enabled = true
vim.g.codeium_disable_bindings = true -- We'll define our own keymaps
vim.g.codeium_no_map_tab = true       -- Don't map Tab key
vim.g.codeium_render = true           -- Enable rendering
vim.g.codeium_manual = true           -- Manual trigger mode
vim.g.codeium_tab_fallback = "\t"     -- Fallback for Tab key

-- Codeium keymaps
vim.keymap.set('i', '<M-[>', function()
  return vim.fn['codeium#CycleCompletions'](-1)
end, { expr = true, silent = true, desc = 'Previous Codeium suggestion' })

vim.keymap.set('i', '<M-]>', function()
  return vim.fn['codeium#CycleOrComplete']()
end, { expr = true, silent = true, desc = 'Next Codeium suggestion or complete' })

vim.keymap.set('i', '<M-x>', function()
  return vim.fn['codeium#Clear']()
end, { expr = true, silent = true, desc = 'Clear Codeium suggestions' })

-- NOTE: ** Refer to keymaps.lua for codeium#accept

vim.api.nvim_create_user_command("EnableCodeium", "Codeium Enable", { desc = "Enable Codeium" })
vim.api.nvim_create_user_command("DisableCodeium", "Codeium Disable", { desc = "Disable Codeium" })
vim.keymap.set('n', '<leader>ce', ':EnableCodeium<CR>', { desc = 'Enable Codeium' })
vim.keymap.set('n', '<leader>cd', ':DisableCodeium<CR>', { desc = 'Disable Codeium' })
vim.keymap.set('n', '<leader>cs', ':Codeium<CR>', { desc = 'Codeium status' })

vim.g.codeium_filetypes = {
  -- Compiled languages
  ["cs"] = true,
  ["java"] = true,
  ["kotlin"] = true,
  ["c"] = true,
  ["cpp"] = true,

  -- Scripting languages
  ["vim"] = true,
  ["python"] = true,
  ["lua"] = true,
  ["javascript"] = true,
  ["javascriptreact"] = true,
  ["typescript"] = true,
  ["typescriptreact"] = true,

  -- Web technologies
  ["html"] = true,
  ["css"] = true,
  ["sass"] = true,
  ["scss"] = true,
  ["json"] = true,

  -- Mobile development
  ["flutter"] = true,
  ["dart"] = true,

  -- DevOps and configuration
  ["docker"] = true,
  ["dockerfile"] = true,
  ["yaml"] = true,
  ["toml"] = true,
  ["terraform"] = true,

  -- Databases
  ["sql"] = true,

  -- Shell scripting
  ["sh"] = true,
  ["bash"] = true,
  ["zsh"] = true,

  -- Disable for certain file types
  ["markdown"] = false,
  ["help"] = false,
  ["gitcommit"] = false,
  ["gitrebase"] = false,
  ["fugitive"] = false,
  ["hgcommit"] = false,
  ["svn"] = false,
  ["cvs"] = false,
  ["."] = false,  -- Files starting with .
}
