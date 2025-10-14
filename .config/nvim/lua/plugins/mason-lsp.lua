require('mason-lspconfig').setup({
  ensure_installed = {
    'vimls',
    'lua_ls',
    'bashls',
    'marksman',

    'emmet_ls',
    'html',
    'cssls',
    'ts_ls',
    'eslint',

    'jsonls',
    'yamlls',
    'dockerls',
  },
})

local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
lsp_capabilities =
  vim.tbl_deep_extend('force', lsp_capabilities, require('cmp_nvim_lsp').default_capabilities())

vim.lsp.config('*', {
  root_markers = { '.git' },
  capabilities = lsp_capabilities,
  on_attach = function(client, bufnr)
    -- Enable formatting if the client supports it
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
        vim.lsp.buf.format({ async = true })
      end, { desc = 'Format current document' })
    end
  end,
})

vim.lsp.config('lua_ls', {
  capabilities = lsp_capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
})

vim.lsp.config('ts_ls', {
  capabilities = lsp_capabilities,
  on_attach = function(client, bufnr)
    vim.api.nvim_create_user_command('OrganizeImports', function()
      vim.lsp.buf_request(0, 'workspace/executeCommand', {
        command = '_typescript.organizeImports',
        arguments = { vim.api.nvim_buf_get_name(0) },
      })
    end, { desc = 'Organize imports (TypeScript)' })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspTypescriptSourceAction', function()
      local source_actions = vim.tbl_filter(function(action)
        return vim.startswith(action, 'source.')
      end, client.server_capabilities.codeActionProvider.codeActionKinds)

      vim.lsp.buf.code_action({
        context = {
          only = source_actions,
        },
      })
    end, {})
  end,
})

vim.lsp.config('eslint', {
  capabilities = lsp_capabilities,
  settings = {
    eslint = {
      format = { enable = true },
    },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'EslintFixAll', function()
      local params = {
        command = 'eslint.applyAllFixes',
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
            version = vim.lsp.util.buf_versions[bufnr],
          },
        },
      }
      client.request('workspace/executeCommand', params, nil, bufnr)
    end, { desc = 'Fix all ESLint issues' })

    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        vim.cmd('EslintFixAll')
      end,
    })
  end,
})
