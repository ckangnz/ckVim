require('mason-conform').setup()

require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
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
