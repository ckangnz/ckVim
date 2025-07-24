local M = {}

local function toggle_whitespace_match(mode)
  local pattern = (mode == 'i') and '\\s\\+\\%#\\@<!$' or '\\s\\+$'

  local excluded_filetypes = {'ctrlsf', 'help', 'codecompanion', 'mcphub'}
  local current_filetype = vim.bo.filetype
  for _, ft in ipairs(excluded_filetypes) do
    if ft == current_filetype then
      if vim.w.whitespace_match_number then
        vim.fn.matchdelete(vim.w.whitespace_match_number)
        vim.w.whitespace_match_number = nil
      end
      return
    end
  end

  if vim.w.whitespace_match_number then
    vim.fn.matchdelete(vim.w.whitespace_match_number)
    vim.w.whitespace_match_number = vim.fn.matchadd('ExtraWhitespace', pattern, 10, vim.w.whitespace_match_number)
  else
    vim.w.whitespace_match_number = vim.fn.matchadd('ExtraWhitespace', pattern)
  end
end
local whitespace_group = vim.api.nvim_create_augroup('WhitespaceMatch', { clear = true })
vim.api.nvim_create_autocmd({'BufWinEnter', 'InsertLeave'}, {
  group = whitespace_group,
  callback = function()
    toggle_whitespace_match('n')
  end,
})
vim.api.nvim_create_autocmd('InsertEnter', {
  group = whitespace_group,
  callback = function()
    toggle_whitespace_match('i')
  end,
})

local function setup_highlights()
  vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = Colors.dark_red, ctermbg = 'red' })
  vim.api.nvim_set_hl(0, 'Search', { fg = Colors.black, bg = Colors.white, ctermfg = 'black', ctermbg = 'white' })
  vim.api.nvim_set_hl(0, 'CurSearch', { reverse = true, bold = true, cterm = { reverse = true, bold = true } })
  vim.api.nvim_set_hl(0, 'CodeiumSuggestion', { fg = Colors.light_grey, ctermfg = 245 })
  if not vim.g.neovide then
    local transparent_groups = {
      'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
      'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String',
      'Function', 'Conditional', 'Repeat', 'Operator', 'Structure',
      'LineNr', 'NonText', 'SignColumn', 'CursorLine', 'CursorLineNr',
      'StatusLine', 'StatusLineNC', 'TabLine', 'TabLineFill', 'EndOfBuffer'
    }

    for _, group in ipairs(transparent_groups) do
      vim.api.nvim_set_hl(0, group, { bg = 'NONE', ctermbg = 'NONE' })
    end

    vim.api.nvim_set_hl(0, 'CodeCompanion', { bg = Colors.black, fg = Colors.white })
    vim.api.nvim_set_hl(0, 'CodeCompanionNormal', { bg = Colors.black, fg = Colors.white })
    vim.api.nvim_set_hl(0, 'CodeCompanionBorder', { bg = Colors.black, fg = Colors.light_grey })
  end
  vim.api.nvim_set_hl(0, 'VertSplit', { fg = Colors.white, ctermfg = 'white' })
end
setup_highlights()

return M
