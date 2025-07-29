require("mason-lspconfig").setup({
  ensure_installed = {
    "vimls",
    "lua_ls",
    "bashls",
    "marksman",

    "emmet_ls",
    "html",
    "cssls",
    "ts_ls",

    "jsonls",
    "yamlls",
    "dockerls",
  },
})

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = lsp_capabilities,
  on_attach = function(client, bufnr)
    -- Enable formatting if the client supports it
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
        vim.lsp.buf.format({ async = true })
      end, { desc = "Format current document" })
    end
  end,
})
vim.lsp.config("lua_ls", {
  capabilities = lsp_capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})
vim.lsp.config("ts_ls", {
  capabilities = lsp_capabilities,
  on_attach = function(client, bufnr)
    vim.lsp.config.ts_ls.on_attach(client, bufnr)

    vim.api.nvim_create_user_command("OrganizeImports", function()
      vim.lsp.buf_request(0, "workspace/executeCommand", {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
      })
    end, { desc = "Organize imports (TypeScript)" })

    vim.api.nvim_buf_create_user_command(bufnr, "LspTypescriptSourceAction", function()
      local source_actions = vim.tbl_filter(function(action)
        return vim.startswith(action, "source.")
      end, client.server_capabilities.codeActionProvider.codeActionKinds)

      vim.lsp.buf.code_action({
        context = {
          only = source_actions,
        },
      })
    end, {})
  end,
})
