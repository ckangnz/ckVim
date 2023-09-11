vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source $HOME/.vimrc
]])

vim.cmd([[
set foldmethod=expr
set foldexpr='nvim_treesitter#foldexpr()'
set foldenable
set foldlevel=99
set foldlevelstart=99
]])

require 'plugins.telescope'
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
