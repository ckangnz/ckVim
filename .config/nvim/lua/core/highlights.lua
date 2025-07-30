vim.api.nvim_set_hl(0, 'ExtraWhitespace', {
  bg = Colors.red,
  fg = Colors.white,
})

-- Search highlights
vim.api.nvim_set_hl(
  0,
  'Search',
  { fg = Colors.black, bg = Colors.white, ctermfg = 'black', ctermbg = 'white' }
)
vim.api.nvim_set_hl(0, 'CurSearch', { reverse = true, bold = true })

-- UI elements
vim.api.nvim_set_hl(0, 'VertSplit', { fg = Colors.white, ctermfg = 'white' })
vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = Colors.light_red, ctermbg = 'red' })

-- Plugin highlights
vim.api.nvim_set_hl(0, 'CodeiumSuggestion', { fg = Colors.light_grey, ctermfg = 245 })

local function apply_custom_highlights()
  vim.api.nvim_set_hl(0, 'Comment', {
    fg = '#928374',
    italic = true,
  })
  vim.api.nvim_set_hl(0, 'TabLine', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TabLineSel', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'CmdLine', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'MsgArea', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'NONE' })
end
apply_custom_highlights()
-- Reapply after colorscheme changes
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('TransparentUI', { clear = true }),
  callback = apply_custom_highlights,
  desc = 'Apply transparent backgrounds after colorscheme changes',
})
