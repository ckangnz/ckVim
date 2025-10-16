require('mason-conform').setup()

require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    zsh = { 'shfmt' },
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescriptreact = { 'prettier' },
    json = { 'prettier' },
    html = { 'prettier' },
    css = { 'prettier' },
    scss = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
    ['_'] = { 'trim_whitespace' },
  },
  default_format_opts = { timeout_ms = 500 },
  format_on_save = {
    lsp_format = 'fallback',
    timeout_ms = 500,
  },
  notify_on_error = true,
  notify_no_formatters = true,
  formatters = {
    stylua = {
      args = {
        '--indent-type',
        'Spaces',
        '--indent-width',
        '2',
        '--column-width',
        '100',
        '--quote-style',
        'ForceSingle',
        '-',
      },
    },
    shfmt = {
      args = {
        '-ln',
        'bash',
      },
    },
    prettier = {
      args = {
        '--stdin-filepath',
        '$FILENAME',
      },
    },
  },
})

vim.api.nvim_create_user_command('Format', function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ['end'] = { args.line2, end_line:len() },
    }
  end
  require('conform').format({ async = true, lsp_fallback = true, range = range })
end, { range = true })
