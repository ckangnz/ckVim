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

-- ExtraWhitespace highlights
local function toggle_whitespace_match(mode)
  local excluded_filetypes =
    { 'ctrlsf', 'help', 'codecompanion', 'mcphub', 'lazy', 'mason', 'alpha' }
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
vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter', 'InsertLeave' }, {
  group = whitespace_group,
  callback = function()
    -- Defer the check to ensure filetype is set
    vim.defer_fn(function()
      toggle_whitespace_match('n')
    end, 0)
  end,
})
vim.api.nvim_create_autocmd('InsertEnter', {
  group = whitespace_group,
  callback = function()
    vim.defer_fn(function()
      toggle_whitespace_match('i')
    end, 0)
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
autocmd('LspAttach', {
  group = lsp_group,
  desc = 'LSP config',
  callback = function()
    vim.keymap.set('n', 'K', vim.diagnostic.open_float, { silent = true, desc = 'Show hover' })
    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { silent = true, desc = 'Rename' })
    vim.keymap.set(
      'n',
      '[d',
      vim.diagnostic.goto_prev,
      { silent = true, desc = 'Previous Diagnostic' }
    )
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { silent = true, desc = 'Next Diagnostic' })
    vim.keymap.set('n', 'gra', vim.lsp.buf.code_action, { silent = true, desc = 'Code Action' })
    vim.keymap.set('n', 'grr', vim.lsp.buf.references, { silent = true, desc = 'References' })
    vim.keymap.set(
      'n',
      'gri',
      vim.lsp.buf.implementation,
      { silent = true, desc = 'Implementation' }
    )
    vim.keymap.set(
      'n',
      'grd',
      vim.lsp.buf.definition,
      { silent = true, desc = 'Go to type_definition' }
    )
    vim.keymap.set(
      'n',
      'grt',
      vim.lsp.buf.type_definition,
      { silent = true, desc = 'Type Definition' }
    )
    vim.keymap.set(
      'n',
      'gO',
      vim.lsp.buf.document_symbol,
      { silent = true, desc = 'Document Symbols' }
    )
    vim.keymap.set('n', 'gq', vim.lsp.formatexpr, { silent = true, desc = 'Format' })

    vim.lsp.inlay_hint.enable(false)
  end,
})
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
