require('mason-nvim-lint').setup()

local lint = require('lint')
lint.linters_by_ft = {
  ['*'] = { 'codespell' },
  bash = { 'shellcheck' },
  sh = { 'shellcheck' },
  zsh = { 'shellcheck' },
  markdown = { 'markdownlint' },
  make = { 'checkmake' },
  javascript = { 'eslint_d' },
  typescript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
  json = { 'jsonlint' },
  yaml = { 'yamllint' },
}
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
  callback = function()
    require('lint').try_lint()
  end,
})

lint.linters.shellcheck.args = {
  '--format',
  'json1',
  '--shell=zsh',
  '--exclude=SC1091,SC2034,SC1090,SC2207',
}

lint.linters.markdownlint.args = {
  '--disable',
  'MD013', -- Line length (disables max line length enforcement)
  '--disable',
  'MD033', -- HTML elements (allows raw HTML in markdown)
  '--disable',
  'MD022', -- Headers spacing (headers don't need blank lines around them)
}

-- Configure yamllint to disable line length and document start warnings
lint.linters.yamllint.args = {
  '--format',
  'parsable', -- Output format for nvim-lint parsing
  '--config-data', -- Inline configuration override
  '{extends: relaxed, rules: {line-length: {max: 200}, document-start: disable}}', -- Extend relaxed preset, allow 200 char lines, disable document start requirement
}
