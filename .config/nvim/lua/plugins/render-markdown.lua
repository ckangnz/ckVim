require('render-markdown').setup({
  enabled = true,
  render_modes = { 'n', 'i', 'v', 'V', 'c', 't' },
  latex = { enabled = false },
  heading = {
    sign = true,
    signs = { '󰫎 ' },
    icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
    position = 'overlay', -- Determines how icons fill the available space. right|inline|overlay
    width = 'block',      -- Width of the heading background. | block | full
    left_margin = 0,
    left_pad = 0,
    right_pad = 0,
    min_width = 0,
    border = false,
    border_virtual = false,
    border_prefix = false,
    above = '▄',
    below = '▀',
    backgrounds = { 'DiffAdd', 'DiffAdd', 'DiffAdd', 'DiffAdd', 'DiffAdd', 'DiffAdd', },
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
    above = '▄',
    below = '▀',
    highlight = 'RenderMarkdownCode',
    highlight_language = nil,
    inline_pad = 0,
    highlight_inline = 'RenderMarkdownCodeInline',
  },
})
