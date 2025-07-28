require("mason-lspconfig").setup {
  ensure_installed = {
    'vimls',
    'lua_ls',
    'bashls',
    'marksman',

    'emmet_ls',
    'html',
    'cssls',
    'ts_ls',

    'jsonls',
    'yamlls',
    'dockerls',
  },
}

-- Lua Language Server
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
})
