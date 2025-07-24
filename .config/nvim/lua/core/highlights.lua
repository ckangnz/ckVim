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

-- Search highlights
vim.api.nvim_set_hl(0, 'Search', { fg = Colors.black, bg = Colors.white, ctermfg = 'black', ctermbg = 'white' })
vim.api.nvim_set_hl(0, 'CurSearch', { reverse = true, bold = true })

-- UI elements
vim.api.nvim_set_hl(0, 'VertSplit', { fg = Colors.light_grey, ctermfg = 'white' })
vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = Colors.dark_red, ctermbg = 'red' })

-- Plugin highlights
vim.api.nvim_set_hl(0, 'CodeiumSuggestion', { fg = Colors.light_grey, ctermfg = 245 })

-- Remove backgrounds for transparent UI
vim.api.nvim_set_hl(0, 'TabLine', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TabLineSel', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'CmdLine', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'MsgArea', { bg = 'NONE' })
