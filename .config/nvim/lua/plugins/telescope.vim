nnoremap <silent><nowait><C-p>    <cmd>lua require('telescope.builtin').git_files()<CR>
nnoremap <silent><nowait><C-e>    <cmd>lua require('telescope.builtin').oldfiles()<CR>
nnoremap <silent><nowait><leader>f <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <silent><nowait><leader>b <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <silent><nowait><leader>h <cmd>lua require('telescope.builtin').help_tags()<cr>

lua << EOF
local colors = {
  bg0     = '#1d2021',
  bg1  = '#282828',
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
