local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

-- Set header
dashboard.section.header.val = {
  '                                       ',
  ' ██████╗██╗  ██╗██╗   ██╗██╗███╗   ███╗',
  '██╔════╝██║ ██╔╝██║   ██║██║████╗ ████║',
  '██║     █████╔╝ ██║   ██║██║██╔████╔██║',
  '██║     ██╔═██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║',
  '╚██████╗██║  ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║',
  ' ╚═════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝',
  '                                       ',
}

-- keys
dashboard.section.buttons.val = {
  dashboard.button('C-p', '󰈞  Find file', ':Telescope find_files <CR>'),
  dashboard.button('C-e', '  Recent files', ':Telescope oldfiles <CR>'),
  dashboard.button('<leader>ev', '  Init.lua', '<cmd>e $HOME/.config/nvim/init.lua<cr>'),
  dashboard.button(
    '<leader>el',
    '󰒲  Lazy.lua',
    '<cmd>e $HOME/.config/nvim/lua/core/lazy.lua<cr>'
  ),
  -- keymaps
  dashboard.button(
    '<leader>ek',
    '󰌚  Keymaps',
    '<cmd>e $HOME/.config/nvim/lua/core/keymaps.lua<cr>'
  ),
  dashboard.button('<leader>ep', ' Plugins', '<cmd>e $HOME/.config/nvim/lua/plugins/<cr>'),
  dashboard.button('n', '  New file', ':ene <BAR> startinsert <CR>'),
  dashboard.button('q', '  Quit Neovim', ':qa<CR>'),
}

-- Set footer
local function footer()
  local version = vim.version()
  local nvim_version_info = '   v' .. version.major .. '.' .. version.minor .. '.' .. version.patch
  return nvim_version_info
end

dashboard.section.footer.val = footer()

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
  autocmd FileType alpha setlocal nofoldenable
]])
