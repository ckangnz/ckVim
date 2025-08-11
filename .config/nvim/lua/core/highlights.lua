local function apply_custom_highlights()
  -- Custom ExtraWhitespace
  vim.api.nvim_set_hl(0, 'ExtraWhitespace', {
    bg = Colors.red,
    fg = Colors.white,
  })

  -- Visual Highlights
  vim.api.nvim_set_hl(0, 'Visual', {
    bg = Colors.dark_grey,
    bold = true,
  })

  -- Comment Highlights
  vim.api.nvim_set_hl(0, 'Comment', {
    fg = Colors.light_grey,
    italic = true,
  })

  -- Search highlights
  vim.api.nvim_set_hl(0, 'Search', { fg = Colors.black, bg = Colors.white })
  vim.api.nvim_set_hl(0, 'CurSearch', { reverse = true, bold = true })

  -- UI elements
  vim.api.nvim_set_hl(0, 'VertSplit', { fg = Colors.white })
  vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = Colors.light_red })

  -- CodeiumSuggestion highlights
  vim.api.nvim_set_hl(0, 'CodeiumSuggestion', { fg = Colors.light_grey })

  -- TransparentUI
  vim.api.nvim_set_hl(0, 'WinBar', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'WinBarNC', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TabLine', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TabLineSel', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'StatusLineTerm', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'CmdLine', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'MsgArea', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'NONE' })
end

HighlightOverride = vim.api.nvim_create_augroup('HighlightOverride', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = HighlightOverride,
  callback = apply_custom_highlights,
  desc = 'Apply transparent backgrounds after colorscheme changes',
})
