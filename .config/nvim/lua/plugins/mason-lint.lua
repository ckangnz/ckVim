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
