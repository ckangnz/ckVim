require('render-markdown').setup({
  enabled = true,
  file_types = { 'markdown', 'codecompanion' },
  render_modes = { 'n', 'i', 'v', 'V', 'c', 't' },
  latex = { enabled = false },
  heading = {
    sign = true,
    signs = { '󰫎 ' },
    icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
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
    above = '▄',
    below = '▀',
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
  overrides = {
    filetype = {
      codecompanion = {
        heading = {
          signs = true,
          border = false,
          position = 'overlay',
          width = 'full',
          custom = {
            codecompanion_llm = {
              pattern = 'CodeCompanion %b()',
              icon = '🤖 ',
              foreground = 'CodeCompanionChatHeaderRobot',
              background = 'CodeCompanionChatHeaderRobot',
            },
            codecompanion_user = {
              pattern = 'You %(User%)',
              icon = '👤 ',
              foreground = 'CodeCompanionChatHeaderMe',
              background = 'CodeCompanionChatHeaderMe',
            },
          },
        },
      },
    },
  },
  html = {
    enabled = true,
    tag = {
      buf = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
      file = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
      help = { icon = '󰘥 ', highlight = 'CodeCompanionChatVariable' },
      image = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
      symbols = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
      url = { icon = '󰖟 ', highlight = 'CodeCompanionChatVariable' },
      var = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
      tool = { icon = ' ', highlight = 'CodeCompanionChatTool' },
      user_prompt = { icon = ' ', highlight = 'CodeCompanionChatTool' },
      group = { icon = ' ', highlight = 'CodeCompanionChatToolGroup' },
    },
  },
})

vim.api.nvim_set_hl(0, 'RenderMarkdownH1Bg', { fg = Colors.light_red })
vim.api.nvim_set_hl(0, 'RenderMarkdownH2Bg', { fg = Colors.light_orange })
vim.api.nvim_set_hl(0, 'RenderMarkdownH3Bg', { fg = Colors.light_yellow })
vim.api.nvim_set_hl(0, 'RenderMarkdownH4Bg', { fg = Colors.light_green })
vim.api.nvim_set_hl(0, 'RenderMarkdownH5Bg', { fg = Colors.light_cyan })
vim.api.nvim_set_hl(0, 'RenderMarkdownH6Bg', { fg = Colors.light_blue })
vim.api.nvim_set_hl(0, 'CodeCompanionChatHeaderMe', { fg = Colors.white, bg = Colors.dark_red })
vim.api.nvim_set_hl(0, 'CodeCompanionChatHeaderRobot', { fg = Colors.white, bg = Colors.dark_blue })
