vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source $HOME/.vimrc
]])

require 'core.myTheme'

--Lua Plugins
require 'plugins.nvim-treesitter'
require 'plugins.telescope'
require 'plugins.tint'
require 'plugins.lualine'
require 'plugins.todo-comments'
require 'plugins.oil'
require 'plugins.autopairs'
require 'plugins.smear-cursor'
require 'plugins.github-preview'

--GUI Config
require 'gui.neovide'

vim.cmd([[
augroup LuaPath
  au!
  au BufRead,BufEnter * setlocal suffixesadd^=.lua
  au BufRead,BufEnter * setlocal suffixesadd^=init.lua
  au BufRead * let &l:path .= ','.stdpath('config').'/lua'
augroup END
]])
