if vim.g.neovide then
  local alpha = function()
    return string.format("%x", math.floor(255 * (vim.g.transparency or 0.95)))
  end

  vim.g.neovide_transparency = 0.0
  vim.g.neovide_background_color = "#1d2021" .. alpha()

  vim.g.neovide_input_use_logo = 1
  vim.g.neovide_floating_blur_amount_x = 20
  vim.g.neovide_floating_blur_amount_y = 20
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
