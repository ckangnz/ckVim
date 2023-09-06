lua << EOF

local telescope = require('telescope')
telescope.setup {
  defaults = {
    layout_config = { prompt_position = "top" },
    sorting_strategy = "ascending",
  }
};

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<C-e>', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>f', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>h', builtin.help_tags, {})

local colors = {
  bg0    = '#1d2021',
  bg1    = '#282828',
  red    = '#ea6962',
  green  = '#a9b665',
  yellow = '#d8a657',
  blue   = '#7daea3',
  aqua   = '#89b482',
  grey   = '#7c6f64',
  purple = '#d3869b',
  fg1    = '#ddc7a1',
  fg0    = '#d4be98',
}

local TelescopeColor = {
  TelescopeMatching = { fg = colors.red },
  TelescopeSelection = { fg = colors.bg1, bg = colors.green, bold = true },

  TelescopePromptTitle = { bg = colors.bg1, fg = colors.fg0 },
  TelescopePromptPrefix = { bg = colors.bg1 },
  TelescopePromptNormal = { bg = colors.bg1 },
  TelescopePromptBorder = { bg = colors.bg1, fg = colors.bg1 },

  TelescopeResultsTitle = { fg = colors.bg1 },
  TelescopeResultsNormal = { bg = colors.bg0 },
  TelescopeResultsBorder = { bg = colors.bg1, fg = colors.bg1 },

  TelescopePreviewTitle = { bg = colors.bg1, fg = colors.bg1 },
  TelescopePreviewNormal = { bg = colors.bg0 },
  TelescopePreviewBorder = { bg = colors.bg1, fg = colors.bg1 },
}

for hl, col in pairs(TelescopeColor) do
  vim.api.nvim_set_hl(0, hl, col)
end
EOF
