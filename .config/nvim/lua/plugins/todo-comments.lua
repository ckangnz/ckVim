require('todo-comments').setup({
  signs = true,
  sign_priority = 8,
  keywords = {
    FIX = {
      icon = ' ',
      color = 'error',
      alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
    },
    TODO = { icon = ' ', color = 'info' },
    HACK = { icon = ' ', color = 'warning' },
    WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
    PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
    NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
    TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
  },
  gui_style = {
    fg = 'NONE',
    bg = 'BOLD',
  },
  merge_keywords = true,
  highlight = {
    multiline = true,
    multiline_pattern = '^.',
    multiline_context = 10,
    before = '',
    keyword = 'wide',
    after = 'fg',
    pattern = [[.*<(KEYWORDS)\s*:]],
    comments_only = true,
    max_line_len = 400,
    exclude = {},
  },
  colors = {
    default = { 'Identifier', '#7C3AED' },
    error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
    hint = { 'DiagnosticHint', '#10B981' },
    info = { 'DiagnosticInfo', '#2563EB' },
    test = { 'Identifier', '#FF00FF' },
    warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
  },
  search = {
    command = 'rg',
    args = {
      '--no-heading',
      '--no-ignore-vcs',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--trim',
      '--hidden',
    },
    pattern = [[\b(KEYWORDS):]],
  },
})

vim.keymap.set('n', '<leader>n', ':TodoTelescope<cr>', {
  desc = 'Search TODO comments',
  silent = true,
  nowait = true,
})
