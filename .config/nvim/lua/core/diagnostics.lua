vim.diagnostic.config({
  virtual_text = {
    severity = { min = vim.diagnostic.severity.ERROR },
    prefix = Icons.circle_fill,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = Icons.error_circle,
      [vim.diagnostic.severity.WARN] = Icons.warn,
      [vim.diagnostic.severity.INFO] = Icons.info,
      [vim.diagnostic.severity.HINT] = Icons.hint,
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
  jump = {
    float = false,
    wrap = true,
  },
})
