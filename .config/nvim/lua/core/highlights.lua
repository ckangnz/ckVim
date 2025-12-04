local function apply_custom_highlights()
  -- Custom ExtraWhitespace
  vim.api.nvim_set_hl(0, 'ExtraWhitespace', {
    bg = Colors.red,
    fg = Colors.white,
  })

  -- Visual Highlights
  vim.api.nvim_set_hl(0, 'Visual', {
    bg = Colors.medium_grey,
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

  -- CodeiumSuggestion highlights
  vim.api.nvim_set_hl(0, 'CodeiumSuggestion', { fg = Colors.light_grey })

  vim.api.nvim_set_hl(0, 'Question', {
    fg = Colors.yellow,
    bold = true,
  })
  vim.api.nvim_set_hl(0, 'MoreMsg', {
    fg = Colors.green,
    bold = true,
  })
  vim.api.nvim_set_hl(0, 'LazyDimmed', { link = 'Comment' })

  vim.api.nvim_set_hl(0, 'NormalFloat', {
    fg = Colors.white,
    bg = Colors.dark_grey,
  })
  vim.api.nvim_set_hl(0, 'FloatBorder', {
    fg = Colors.light_grey,
    bg = Colors.dark_grey,
  })
  vim.api.nvim_set_hl(0, 'FloatTitle', {
    fg = Colors.yellow,
    bg = Colors.dark_grey,
    bold = true,
  })

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
  desc = 'Apply colorscheme overrides',
})
