require("mason-conform").setup({
  ensure_installed = {
    "stylua",
    "prettier",
    "prettierd",
    "markdownlint",
    "codespell",
  },
  ignore_install = {},
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    markdown = { "markdownlint" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    yaml = { "prettier" },
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
  formatters = {
    stylua = {
      args = { "--indent-type", "Spaces", "--indent-width", "2", "--column-width", "100", "-" },
    },
    prettier = {
      args = {
        "--stdin-filepath",
        "$FILENAME",
        "--semi=true",
        "--quote-props=as-needed",
        "--jsx-single-quote=false",
        "--trailing-comma=es5",
        "--single-quote=false",
        "--print-width=100"
      }
    }
  }
})
