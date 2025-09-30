-- Core autocommands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General augroup
local general = augroup('General', { clear = true })
autocmd('TextYankPost', {
  group = general,
  desc = 'Highlight on yank',
  callback = function()
    vim.api.nvim_set_hl(0, 'YankHighlight', { fg = Colors.black, bg = Colors.white, bold = true })
    vim.hl.on_yank({
      higroup = 'YankHighlight',
      timeout = 300,
    })
  end,
})
autocmd('BufEnter', {
  group = general,
  desc = 'Disable auto comment on new line',
  pattern = '*',
  command = 'set fo-=c fo-=r fo-=o',
})

-- Plugin loading augroup
local plugin_loading = augroup('PluginLoading', { clear = true })
autocmd({ 'BufRead', 'BufEnter' }, {
  group = plugin_loading,
  desc = 'Load core plugins',
  pattern = '*',
  callback = function()
    vim.opt.suffixesadd:prepend('.lua')
  end,
})

-- FileType specific augroup
local filetype_specific = augroup('FileTypeSpecific', { clear = true })
autocmd('FileType', {
  group = filetype_specific,
  desc = 'HTTP files settings',
  pattern = { 'http', 'rest' },
  callback = function()
    vim.opt_local.wrap = false
  end,
})
autocmd({ 'BufRead', 'BufNewFile' }, {
  group = filetype_specific,
  desc = 'Set filetype for JavaScript files',
  pattern = { '.env', '.env.local', '.env.development', '.env.production' },
  callback = function()
    vim.bo.filetype = 'ini'
  end,
})
autocmd({ 'BufRead', 'BufNewFile' }, {
  group = filetype_specific,
  desc = 'Set filetype for JavaScript files',
  pattern = { '*.js', '*.mjs', '*.cjs' },
  callback = function()
    vim.bo.filetype = 'javascript'
  end,
})
autocmd({ 'BufRead', 'BufNewFile' }, {
  group = filetype_specific,
  desc = 'Set filetype for JSX files',
  pattern = { '*.jsx' },
  callback = function()
    vim.bo.filetype = 'javascriptreact'
  end,
})
autocmd({ 'BufRead', 'BufNewFile' }, {
  group = filetype_specific,
  desc = 'Set filetype for TypeScript files',
  pattern = { '*.ts', '*.mts', '*.cts' },
  callback = function()
    vim.bo.filetype = 'typescript'
  end,
})
autocmd({ 'BufRead', 'BufNewFile' }, {
  group = filetype_specific,
  desc = 'Set filetype for TSX files',
  pattern = { '*.tsx' },
  callback = function()
    vim.bo.filetype = 'typescriptreact'
  end,
})
autocmd({ 'BufRead', 'BufNewFile' }, {
  group = filetype_specific,
  desc = 'Ensure init.lua files are detected as lua filetype',
  pattern = { 'init.lua', '*/init.lua' },
  callback = function()
    vim.bo.filetype = 'lua'
  end,
})
autocmd({ 'BufRead', 'BufNewFile' }, {
  group = filetype_specific,
  desc = 'Ensure lua files in nvim config are detected as lua filetype',
  pattern = { '*/.config/nvim/*.lua', '*/.config/nvim/**/*.lua' },
  callback = function()
    vim.bo.filetype = 'lua'
  end,
})

-- Terminal augroup
local terminal = augroup('Terminal', { clear = true })
autocmd('TermOpen', {
  group = terminal,
  desc = 'Terminal settings',
  pattern = '*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
  end,
})
autocmd({ 'WinEnter', 'BufWinEnter', 'TermOpen' }, {
  group = terminal,
  desc = 'Auto insert mode in terminal',
  pattern = 'term://*',
  command = 'startinsert',
})

-- ExtraWhitespace highlights
local function toggle_whitespace_match(mode)
  local excluded_filetypes = {
    '',
    'ctrlsf',
    'help',
    'codecompanion',
    'mcphub',
    'lazy',
    'mason',
    'alpha',
    'TelescopePrompt',
    'TelescopeResults',
    'TelescopePreview',
  }
  local current_filetype = vim.bo.filetype

  if vim.tbl_contains(excluded_filetypes, current_filetype) then
    return
  end

  if vim.w.whitespace_match_number then
    pcall(vim.fn.matchdelete, vim.w.whitespace_match_number)
    vim.w.whitespace_match_number = nil
  end

  local pattern = (mode == 'i') and '\\s\\+\\%#\\@<!$' or '\\s\\+$'
  vim.w.whitespace_match_number = vim.fn.matchadd('ExtraWhitespace', pattern, 10)
end
local whitespace_group = vim.api.nvim_create_augroup('WhitespaceMatch', { clear = true })
autocmd({ 'FileType', 'BufWinEnter', 'InsertLeave' }, {
  group = whitespace_group,
  callback = function()
    -- Defer the check to ensure filetype is set
    vim.defer_fn(function()
      toggle_whitespace_match('n')
    end, 0)
  end,
})
autocmd('InsertEnter', {
  group = whitespace_group,
  callback = function()
    vim.defer_fn(function()
      toggle_whitespace_match('i')
    end, 0)
  end,
})
autocmd('BufWinLeave', {
  group = whitespace_group,
  callback = function()
    if vim.w.whitespace_match_number then
      pcall(vim.fn.matchdelete, vim.w.whitespace_match_number)
      vim.w.whitespace_match_number = nil
    end
  end,
})
