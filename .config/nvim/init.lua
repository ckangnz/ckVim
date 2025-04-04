-- Ensure paths are expanded correctly
local home_dir = vim.fn.expand("$HOME")
local vim_dir = home_dir .. "/.vim"
vim.opt.runtimepath:prepend(vim_dir)
vim.opt.packpath = vim.opt.runtimepath:get()
vim.cmd("source " .. home_dir .. "/.vimrc")

require 'core.myTheme'

--Lua Plugins
require 'plugins.nvim-treesitter'
require 'plugins.telescope'
require 'plugins.lualine'
require 'plugins.todo-comments'
require 'plugins.oil'
require 'plugins.autopairs'
require 'plugins.smear-cursor'
require 'plugins.render-markdown'

--GUI Config
require 'gui.neovide'

vim.api.nvim_create_autocmd({ "BufRead", "BufEnter" }, {
  pattern = "*",
  callback = function()
    vim.opt.suffixesadd:prepend(".lua")
  end,
})
