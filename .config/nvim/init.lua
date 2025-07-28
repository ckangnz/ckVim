local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.opt.runtimepath:prepend(config_dir)

-- Also add the lua directory to package.path for module loading
local lua_dir = config_dir .. "/lua"
package.path = lua_dir .. "/?.lua;" .. lua_dir .. "/?/init.lua;" .. package.path

-- Set leader key early
vim.g.mapleader = ','
vim.g.maplocalleader = ','

require('core.theme')
require('core.highlights')

-- Core modules
require('core.options')
require('core.keymaps')
require('core.autocmds')
require('core.lsp')

require('core.lazy')

-- Neovide specific
if vim.g.neovide then
  require('gui.neovide')
end
