if vim.g.neovide then
  vim.o.guifont = 'FiraCode Nerd Font:h12'
  vim.opt.linespace = 5
  vim.g.neovide_opacity = 1
  vim.g.neovide_normal_opacity = 0.9
  vim.g.neovide_window_blurred = true
  vim.g.neovide_scale_factor = 1
  vim.g.neovide_input_use_logo = 1
  vim.g.neovide_floating_blur_amount_x = 20
  vim.g.neovide_floating_blur_amount_y = 20
  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_input_macos_option_key_is_meta = 'both'
  vim.g.neovide_cursor_vfx_mode = 'wireframe'
  vim.g.neovide_fullscreen = false
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5

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
end
