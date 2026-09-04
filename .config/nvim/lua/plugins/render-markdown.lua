require('render-markdown').setup({
  enabled = true,
  file_types = { 'markdown' },
  render_modes = { 'n', 'i', 'v', 'V', 'c', 't' },
  latex = { enabled = false },
  heading = {
    sign = true,
    signs = { Icons.label },
    icons = {
      Icons.number_1,
      Icons.number_2,
      Icons.number_3,
      Icons.number_4,
      Icons.number_5,
      Icons.number_6,
    },
    atx = true,
    setext = true,
    position = 'overlay', -- Determines how icons fill the available space. right|inline|overlay
    width = 'block', -- Width of the heading background. | block | full
    left_margin = 0,
    left_pad = 0,
    right_pad = 0,
    min_width = 0,
    border = false,
    border_virtual = false,
    border_prefix = false,
    above = Icons.block_bottom,
    below = Icons.block_top,
  },
  code = {
    sign = false,
    style = 'full',
    position = 'left',
    language_pad = 0,
    language_name = true,
    disable_background = { 'diff' },
    width = 'full',
    left_margin = 0,
    left_pad = 0,
    right_pad = 0,
    min_width = 0,
    -- Determines how the top / bottom of code block are rendered.
    -- | none  | do not render a border                               |
    -- | thick | use the same highlight as the code body              |
    -- | thin  | when lines are empty overlay the above & below icons |
    border = 'thick',
    above = Icons.block_bottom,
    below = Icons.block_top,
    highlight = 'RenderMarkdownCode',
    highlight_language = nil,
    inline_pad = 0,
    highlight_inline = 'RenderMarkdownCodeInline',
  },
  overrides = {
    filetype = {},
  },
  html = {
    enabled = true,
  },
})

vim.api.nvim_set_hl(0, 'RenderMarkdownH1Bg', { fg = Colors.light_red })
vim.api.nvim_set_hl(0, 'RenderMarkdownH2Bg', { fg = Colors.light_orange })
vim.api.nvim_set_hl(0, 'RenderMarkdownH3Bg', { fg = Colors.light_yellow })
vim.api.nvim_set_hl(0, 'RenderMarkdownH4Bg', { fg = Colors.light_green })
vim.api.nvim_set_hl(0, 'RenderMarkdownH5Bg', { fg = Colors.light_cyan })
vim.api.nvim_set_hl(0, 'RenderMarkdownH6Bg', { fg = Colors.light_blue })
