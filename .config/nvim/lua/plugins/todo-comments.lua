require('todo-comments').setup({
  signs = true, -- show icons in the signs column
  sign_priority = 8, -- sign priority
  keywords = { -- keywords recognized as todo comments
    FIX = {
      icon = ' ', -- icon used for the sign, and in search results
      color = 'error', -- can be a hex color, or a named color (see below)
      alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = ' ', color = 'info' },
    HACK = { icon = ' ', color = 'warning' },
    WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
    PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
    NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
    TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
  },
  gui_style = {
    fg = 'NONE', -- The gui style to use for the fg highlight group.
    bg = 'BOLD', -- The gui style to use for the bg highlight group.
  },
  merge_keywords = true, -- when true, custom keywords will be merged with the defaults
  -- highlighting of the line containing the todo comment
  -- * before: highlights before the keyword (typically comment characters)
  -- * keyword: highlights of the keyword
  -- * after: highlights after the keyword (todo text)
  highlight = {
    multiline = true, -- enable multine todo comments
    multiline_pattern = '^.', -- lua pattern to match the next multiline from the start of the matched keyword
    multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
    before = '', -- "fg" or "bg" or empty
    keyword = 'wide', -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
    after = 'fg', -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
    exclude = {}, -- list of file types to exclude highlighting
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
    -- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  },
})

-- Keymaps
vim.keymap.set('n', '<leader>n', ':TodoTelescope<cr>', {
  desc = 'Search TODO comments',
  silent = true,
  nowait = true,
})
