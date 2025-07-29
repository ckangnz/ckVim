require("mason-nvim-lint").setup({
  ensure_installed = {
    "shellcheck",
    "markdownlint",
    "eslint_d",
    "jsonlint",
    "yamllint",
    "hadolint",
  },
})

local lint = require("lint")
lint.linters_by_ft = {
  bash = { "shellcheck" },
  sh = { "shellcheck" },
  zsh = { "shellcheck" },
  markdown = { "markdownlint" },
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  json = { "jsonlint" },
  yaml = { "yamllint" },
  dockerfile = { "hadolint" },
}

-- Auto-run linting on save and text change
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
