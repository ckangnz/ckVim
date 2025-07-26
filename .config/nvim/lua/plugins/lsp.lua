vim.diagnostic.config({
  virtual_text = {
    severity = { min = vim.diagnostic.severity.ERROR },
    prefix = '●',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌶",
    }
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
})

-- "K" is mapped in Normal mode to |vim.lsp.buf.hover()|
-- "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
-- "[d" is mapped in Normal  mode to |vim.diagnostic.goto_prev()|
-- "]d" is mapped in Normal  mode to |vim..diagnostic.goto_next()|
-- "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
-- "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
-- "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
-- "grt" is mapped in Normal mode to |vim.lsp.buf.type_definition()|
-- "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
-- "gq" is mapped in Normal mode to |vim.lsp.formatexpr()|
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { silent = true, desc = 'Go to type_definition' })

require("mason-lspconfig").setup {
  ensure_installed = {
    'vimls',
    'lua_ls',
    'bashls',

    'emmet_ls',
    'html',
    'cssls',
    'ts_ls',

    'jsonls',
    'yamlls',

    'csharp_ls',
    'pyright',
    'jdtls',

    'marksman',
    'dockerls',
  },
  automatic_enable = true
}

-- Enable format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
  desc = 'Format on save'
})

vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format({ async = true }) end,
  { desc = 'Format current document' })
vim.api.nvim_create_user_command('OrganizeTSImports', function()
  local params = {
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf_request(0, 'workspace/executeCommand', params)
end, { desc = 'Organize imports (TypeScript)' })

vim.lsp.inlay_hint.enable(false)

-- Lua Language Server
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      codeLens = {
        enable = true,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      completion = {
        callSnippet = 'Both',
        requireSeparator = '.',
      },
    },
  },
})
