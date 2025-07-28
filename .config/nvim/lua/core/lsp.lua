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

-- Hide inlay_hint
vim.lsp.inlay_hint.enable(false)

local lsp_group = vim.api.nvim_create_augroup('LSPGroup', { clear = true })
-- Enable format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = lsp_group,
  pattern = '*',
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf })
    for _, client in ipairs(clients) do
      if client.supports_method('textDocument/formatting') then
        vim.lsp.buf.format({ async = false, bufnr = args.buf })
        break
      end
    end
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
