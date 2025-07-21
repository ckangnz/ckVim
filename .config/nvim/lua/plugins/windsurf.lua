vim.g.codeium_enabled = true
vim.g.codeium_disable_bindings = true
vim.g.codeium_no_map_tab = true
vim.g.codeium_render = true
vim.g.codeium_manual = true
vim.g.codeium_tab_fallback = "\t"

vim.keymap.set('i', '<M-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
  { expr = true, silent = true })
vim.keymap.set('i', '<M-]>', function() return vim.fn['codeium#CycleOrComplete']() end, { expr = true, silent = true })
vim.keymap.set('i', '<M-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })

vim.api.nvim_create_user_command("EnableCodeium", ":Codeium Enable", {})
vim.api.nvim_create_user_command("DisableCodeium", "Codeium Disable", {})

vim.g.codeium_filetypes = {
  ["cs"] = true,
  ["vim"] = true,
  ["python"] = true,
  ["html"] = true,
  ["css"] = true,
  ["sass"] = true,
  ["json"] = true,
  ["flutter"] = true,
  ["kotlin"] = true,
  ["lua"] = true,
  ["docker"] = true,
  ["javascript"] = true,
  ["javascriptreact"] = true,
  ["typescript"] = true,
  ["typescriptreact"] = true,
  yaml = false,
  markdown = false,
  help = false,
  gitcommit = false,
  gitrebase = false,
  fugitive = false,
  hgcommit = false,
  svn = false,
  cvs = false,
  ["."] = false,
}
