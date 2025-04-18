-- ---------AI Toolkit: Exafunction/codeium.vim
-- Run :Codeium Auth to set up
vim.g.codeium_disable_bindings = 1
vim.g.codeium_no_map_tab = false
vim.g.codeium_render = true
vim.g.codeium_manual = true

vim.keymap.set('i', '<C-d>', function() return vim.fn['codeium#CycleOrComplete']() end,
  { expr = true, silent = true })
vim.keymap.set('i', '<C-s>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
  { expr = true, silent = true })
vim.keymap.set('i', '<C-f>', function() return vim.fn['codeium#Complete'](-1) end, { expr = true, silent = true })

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
  ["typescriptreact"] = true
}
