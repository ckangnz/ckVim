-- Core autocommands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General augroup
local general = augroup('General', { clear = true })
autocmd('TextYankPost', {
  group = general,
  desc = 'Highlight on yank',
  callback = function()
    vim.hl.on_yank()
  end,
})
autocmd('BufWritePre', {
  group = general,
  desc = 'Remove trailing whitespace',
  pattern = '*',
  command = [[%s/\s\+$//e]],
})
autocmd('BufEnter', {
  group = general,
  desc = 'Disable auto comment on new line',
  pattern = '*',
  command = 'set fo-=c fo-=r fo-=o',
})

-- Plugin loading augroup
local plugin_loading = augroup('PluginLoading', { clear = true })
autocmd({ 'BufRead', 'BufEnter' }, {
  group = plugin_loading,
  desc = 'Load core plugins',
  pattern = '*',
  callback = function()
    vim.opt.suffixesadd:prepend('.lua')
  end,
})

-- FileType specific augroup
local filetype_specific = augroup('FileTypeSpecific', { clear = true })
autocmd('FileType', {
  group = filetype_specific,
  desc = 'HTTP files settings',
  pattern = { 'http', 'rest' },
  callback = function()
    vim.opt_local.wrap = false
  end,
})

-- Ensure proper filetype detection for init.lua and nvim config files
autocmd({ 'BufRead', 'BufNewFile' }, {
  group = filetype_specific,
  desc = 'Ensure init.lua files are detected as lua filetype',
  pattern = { 'init.lua', '*/init.lua' },
  callback = function()
    vim.bo.filetype = 'lua'
  end,
})
autocmd({ 'BufRead', 'BufNewFile' }, {
  group = filetype_specific,
  desc = 'Ensure lua files in nvim config are detected as lua filetype',
  pattern = { '*/.config/nvim/*.lua', '*/.config/nvim/**/*.lua' },
  callback = function()
    vim.bo.filetype = 'lua'
  end,
})

-- Terminal augroup
local terminal = augroup('Terminal', { clear = true })
autocmd('TermOpen', {
  group = terminal,
  desc = 'Terminal settings',
  pattern = '*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
  end,
})
autocmd({ 'WinEnter', 'BufWinEnter', 'TermOpen' }, {
  group = terminal,
  desc = 'Auto insert mode in terminal',
  pattern = 'term://*',
  command = 'startinsert',
})
autocmd('BufLeave', {
  group = terminal,
  desc = 'Close terminal on exit',
  pattern = 'term://*',
  command = 'stopinsert',
})
