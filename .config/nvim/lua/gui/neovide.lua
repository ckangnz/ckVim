vim.g.neovide_scale_factor = 1.3 -- font size
vim.g.neovide_input_use_logo = 1
vim.g.neovide_floating_blur_amount_x = 20
vim.g.neovide_floating_blur_amount_y = 20
vim.g.neovide_scroll_animation_length = 0.3
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_remember_window_size = true
vim.g.neovide_input_macos_option_key_is_meta = 'both'
vim.g.neovide_cursor_vfx_mode = 'wireframe'
vim.g.neovide_fullscreen = false

-- Keymaps for macOS-style shortcuts
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Copy/Paste
map('v', '<D-c>', '"+y<CR>', { desc = 'Copy to clipboard' })
map('', '<D-v>', '"+p<CR>', { desc = 'Paste from clipboard' })
map('!', '<D-v>', '<C-R>+', { desc = 'Paste from clipboard' })
map('t', '<D-v>', '<C-R>+', { desc = 'Paste from clipboard' })

-- Save
map('', '<D-s>', ':w<CR>', { desc = 'Save file' })

-- Tab management
map('', '<D-t>', ':tabedit<cr>', { desc = 'New tab' })
map('', '<D-{>', 'gT', { desc = 'Previous tab' })
map('', '<D-}>', 'gt', { desc = 'Next tab' })

-- Close operations
map('', '<D-w>', ':wq<cr>', { desc = 'Close buffer' })
map('', '<D-q>', ':wqa<cr>', { desc = 'Close everything' })
