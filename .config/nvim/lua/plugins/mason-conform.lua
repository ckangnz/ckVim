require('mason-conform').setup()

require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    zsh = { 'shfmt' },
    javascript = { 'prettierd', 'prettier' },
    typescript = { 'prettierd', 'prettier' },
    javascriptreact = { 'prettierd', 'prettier' },
    typescriptreact = { 'prettierd', 'prettier' },
    json = { 'prettier' },
    html = { 'prettier' },
    css = { 'prettier' },
    scss = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettierd' },
    ['_'] = { 'trim_whitespace' },
  },
  default_format_opts = {
    lsp_format = 'fallback',
    stop_after_first = true,
  },
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
    prettier = {
      args = {
        '--stdin-filepath',
        '$FILENAME',
        '--semi=true',
        '--quote-props=as-needed',
        '--jsx-single-quote=false',
        '--trailing-comma=es5',
        '--single-quote=false',
        '--print-width=100',
      },
    },
  },
})
