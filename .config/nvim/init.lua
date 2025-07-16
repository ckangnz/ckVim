local home_dir = vim.fn.expand("$HOME")
local vim_dir = home_dir .. "/.vim"
vim.opt.runtimepath:prepend(vim_dir)
vim.opt.packpath = vim.opt.runtimepath:get()
vim.cmd("source " .. home_dir .. "/.vimrc")

require 'core.myTheme'
require 'core.keymaps'

vim.api.nvim_create_autocmd({ 'BufRead', 'BufEnter' }, {
  pattern = '*',
  callback = function()
    require 'plugins.lualine'
    require 'plugins.nvim-treesitter'
    require 'plugins.oil'
    require 'plugins.smear-cursor'
    require 'plugins.telescope'
    require 'plugins.todo-comments'
    require 'plugins.windsurf'

    vim.opt.suffixesadd:prepend('.lua')
  end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  callback = function()
    require 'plugins.copilot'
    require 'plugins.autopairs'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'md' },
  callback = function()
    require 'plugins.render-markdown'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { "http", "rest" },
  callback = function()
    require 'plugins.kulala'
  end,
})

--GUI Config
require 'gui.neovide'
