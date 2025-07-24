-- Keymaps
vim.keymap.set('n', 'F', '<Plug>(easymotion-overwin-f2)', {
  desc = 'EasyMotion: Jump to 2 characters'
})

-- Highlight groups
vim.api.nvim_set_hl(0, 'EasyMotionTarget', { link = 'EasyMotionIncSearch' })
vim.api.nvim_set_hl(0, 'EasyMotionShade', { link = 'Comment' })
vim.api.nvim_set_hl(0, 'EasyMotionIncSearch', { link = 'IncSearch' })
