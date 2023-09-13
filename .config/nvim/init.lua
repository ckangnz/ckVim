vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source $HOME/.vimrc
]])

--Lua Plugins
require 'plugins.nvim-treesitter'
require 'plugins.telescope'
require 'plugins.tint'
require 'plugins.lualine'

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
