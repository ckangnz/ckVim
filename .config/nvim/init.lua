vim.cmd([[
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal suffixesadd^=.lua
setlocal suffixesadd^=init.lua
let &l:path .= ','.stdpath('config').'/lua'
]])
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

-- TREESITTER
require 'plugins.nvim-treesitter'

--NEOVIDE Config
if vim.g.neovide then
  vim.g.neovide_input_use_logo = 1
  vim.g.neovide_floating_blur_amount_x = 2
  vim.g.neovide_floating_blur_amount_y = 2
  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_vfx_mode = "wireframe"
  vim.g.neovide_fullscreen = false

  vim.keymap.set('v', '<D-c>', '"+y<CR>')     --copy
  vim.keymap.set('', '<D-v>', '"+p<CR>')      --paste
  vim.keymap.set('!', '<D-v>', '<C-R>+')      --paste
  vim.keymap.set('t', '<D-v>', '<C-R>+')      --paste

  vim.keymap.set('', '<D-s>', ':w<CR>')       --save

  vim.keymap.set('', '<D-t>', ':tabedit<cr>') --new tab
  vim.keymap.set('', '<D-[>', 'gT')           --previous tab
  vim.keymap.set('', '<D-]>', 'gt')           --next tab
end
