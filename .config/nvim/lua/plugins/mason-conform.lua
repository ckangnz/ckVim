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
