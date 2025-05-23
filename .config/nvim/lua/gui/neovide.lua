if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.3 --font size
  vim.g.neovide_input_use_logo = 1
  vim.g.neovide_floating_blur_amount_x = 20
  vim.g.neovide_floating_blur_amount_y = 20
  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_input_macos_option_key_is_meta = 'both'
  vim.g.neovide_cursor_vfx_mode = "wireframe"
  vim.g.neovide_fullscreen = false

  vim.keymap.set('v', '<D-c>', '"+y<CR>')     --copy
  vim.keymap.set('', '<D-v>', '"+p<CR>')      --paste
  vim.keymap.set('!', '<D-v>', '<C-R>+')      --paste
  vim.keymap.set('t', '<D-v>', '<C-R>+')      --paste

  vim.keymap.set('', '<D-s>', ':w<CR>')       --save

  vim.keymap.set('', '<D-t>', ':tabedit<cr>') --new tab
  vim.keymap.set('', '<D-{>', 'gT')           --previous tab
  vim.keymap.set('', '<D-}>', 'gt')           --next tab

  vim.keymap.set('', '<D-w>', ':wq<cr>')      --close buffer
  vim.keymap.set('', '<D-q>', ':wqa<cr>')     --close everything
end
