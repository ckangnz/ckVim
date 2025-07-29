require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    markdown = { "markdownlint" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    ["*"] = { "codespell" },
    ["_"] = { "trim_whitespace" },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },
  notify_on_error = true,
  notify_no_formatters = true,
})

require('conform').formatters = {
  stylua = {
    args = { "--indent-type", "Spaces", "--indent-width", "2", "--column-width", "100" },
  },
  prettier = {
    args = {
      "--semi=true",
      "--quote-props=as-needed",
      "--jsx-single-quote=false",
      "--trailing-comma=es5",
      "--single-quote=false",
      "--print-width=100"
    }
  }
}
