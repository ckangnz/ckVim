-- Core autocommands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General augroup
local general = augroup('General', { clear = true })
autocmd('TextYankPost', {
  group = general,
  desc = 'Highlight on yank',
  callback = function()
    vim.hl.on_yank()
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

-- Ensure proper filetype detection for init.lua and nvim config files
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

-- WhitespaceMatch
local function toggle_whitespace_match(mode)
  local pattern = (mode == 'i') and '\\s\\+\\%#\\@<!$' or '\\s\\+$'
  local excluded_filetypes = { 'ctrlsf', 'help', 'codecompanion', 'mcphub', 'lazy', 'mason' }
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
    pcall(vim.fn.matchdelete, vim.w.whitespace_match_number)
  end
  vim.w.whitespace_match_number = vim.fn.matchadd('ExtraWhitespace', pattern, 10)
end

local whitespace_group = vim.api.nvim_create_augroup('WhitespaceMatch', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'InsertLeave' }, {
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
vim.api.nvim_create_autocmd('BufWinLeave', {
  group = whitespace_group,
  callback = function()
    if vim.w.whitespace_match_number then
      pcall(vim.fn.matchdelete, vim.w.whitespace_match_number)
      vim.w.whitespace_match_number = nil
    end
  end,
})

local lsp_group = vim.api.nvim_create_augroup('LSPGroup', { clear = true })
autocmd('BufWritePre', {
  group = lsp_group,
  desc = 'Format on save',
  pattern = '*',
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf })
    for _, client in ipairs(clients) do
      if client.supports_method('textDocument/formatting') then
        vim.lsp.buf.format({ async = false, bufnr = args.buf })
        break
      end
    end
  end,
})
autocmd('LspAttach', {
  group = lsp_group,
  desc = 'LSP config',
  callback = function()
    -- LSP Keymaps (defaults)
    -- "K" is mapped in Normal mode to |vim.lsp.buf.hover()|
    -- "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
    -- "[d" is mapped in Normal  mode to |vim.diagnostic.goto_prev()|
    -- "]d" is mapped in Normal  mode to |vim..diagnostic.goto_next()|
    -- "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
    -- "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
    -- "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
    -- "grt" is mapped in Normal mode to |vim.lsp.buf.type_definition()|
    -- "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
    -- "gq" is mapped in Normal mode to |vim.lsp.formatexpr()|
    vim.keymap.set(
      'n',
      'gd',
      vim.lsp.buf.definition,
      { silent = true, desc = 'Go to type_definition' }
    )

    vim.lsp.inlay_hint.enable(false)
  end,
})
