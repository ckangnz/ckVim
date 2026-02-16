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
  dashboard.button('C-e', Icons.files .. 'Recent files', ':FzfLua oldfiles <CR>'),
  dashboard.button('C-p', Icons.file_find .. 'Find file', ':FzfLua find_files <CR>'),
  dashboard.button('<leader>1', Icons.git .. 'Git status', ':Git<CR><C-w>k<cmd>q<CR>'),
  dashboard.button(
    '<leader>ev',
    Icons.setting .. 'Init.lua',
    '<cmd>e $HOME/.config/nvim/init.lua<cr>'
  ),
  dashboard.button('<leader>ec', Icons.core .. 'Cores', '<cmd>e $HOME/.config/nvim/lua/core/<cr>'),
  dashboard.button(
    '<leader>el',
    Icons.zzz .. 'Lazy.lua',
    '<cmd>e $HOME/.config/nvim/lua/core/lazy.lua<cr>'
  ),
  dashboard.button(
    '<leader>ek',
    Icons.keyboard .. 'Keymaps',
    '<cmd>e $HOME/.config/nvim/lua/core/keymaps.lua<cr>'
  ),
  -- eh to highlights
  dashboard.button(
    '<leader>eh',
    Icons.palette .. 'Highlight',
    '<cmd>e $HOME/.config/nvim/lua/core/highlights.lua<cr>'
  ),
  dashboard.button(
    '<leader>ep',
    Icons.plug .. 'Plugins',
    '<cmd>e $HOME/.config/nvim/lua/plugins/<cr>'
  ),
  dashboard.button('t', Icons.terminal .. 'Terminal', ':terminal<CR>'),
  dashboard.button('n', Icons.file_new .. 'New file', ':ene <BAR> startinsert <CR>'),
  dashboard.button('q', Icons.exit .. 'Quit Neovim', ':qa<CR>'),
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
