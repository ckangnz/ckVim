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

local opts = { silent = true }

-- Navigation (enhance global defaults)
vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', vim.tbl_extend('force', opts, { desc = 'References' }))
vim.keymap.set('n', 'gs', '<cmd>Telescope lsp_document_symbols<cr>',
  vim.tbl_extend('force', opts, { desc = 'Document symbols' }))
vim.keymap.set('n', 'gS', '<cmd>Telescope lsp_workspace_symbols<cr>',
  vim.tbl_extend('force', opts, { desc = 'Workspace symbols' }))
vim.keymap.set('n', 'gC', '<cmd>Telescope lsp_outgoing_calls<cr>',
  vim.tbl_extend('force', opts, { desc = 'Outgoing calls' }))

-- Documentation with rounded borders
vim.keymap.set('n', 'K', function() vim.lsp.buf.signature_help({ border = 'rounded' }) end,
  vim.tbl_extend('force', opts, { desc = 'Signature help' }))

-- Formatting
vim.keymap.set('n', '<leader>=', function() vim.lsp.buf.format({ async = true }) end,
  vim.tbl_extend('force', opts, { desc = 'Format document' }))
vim.keymap.set('v', '<leader>=', function() vim.lsp.buf.format({ async = true }) end,
  vim.tbl_extend('force', opts, { desc = 'Format selection' }))

-- Diagnostics (enhance global defaults)
vim.keymap.set('n', 'gan', function() vim.diagnostic.jump({ count = 1 }) end,
  vim.tbl_extend('force', opts, { desc = 'Next diagnostic' }))
vim.keymap.set('n', 'gap', function() vim.diagnostic.jump({ count = -1 }) end,
  vim.tbl_extend('force', opts, { desc = 'Previous diagnostic' }))
vim.keymap.set('n', 'ga.', vim.lsp.buf.code_action, { silent = true, desc = 'Code action' })
vim.keymap.set('v', 'ga', vim.lsp.buf.code_action, { silent = true, desc = 'Code action for selection' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,
  vim.tbl_extend('force', opts, { desc = 'Diagnostics to loclist' }))

local preferred_servers = {
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
}

require("mason-lspconfig").setup {
  ensure_installed = preferred_servers,
  automatic_enable = {
    "lua_ls",
    "vimls"
  }
}

vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format({ async = true }) end,
  { desc = 'Format current document' })

vim.api.nvim_create_user_command('OrganizeImports', function()
  local params = {
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf_request(0, 'workspace/executeCommand', params)
end, { desc = 'Organize imports (TypeScript)' })

-- Enable format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
  desc = 'Format on save'
})

-- LSP Server configurations using vim.lsp.config
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.inlay_hint.enable(false)

-- Lua Language Server
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

-- TypeScript/JavaScript
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
  settings = {
    typescript = {
      format = {
        enable = true,
      },
      updateImportsOnFileMove = {
        enabled = 'always',
      },
    },
    javascript = {
      format = {
        enable = true,
      },
    },
  },
  on_attach = function(client, bufnr)
    -- Auto-organize imports on save for TypeScript files
    if client.name == 'ts_ls' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function()
          local params = {
            command = '_typescript.organizeImports',
            arguments = { vim.api.nvim_buf_get_name(bufnr) },
          }
          vim.lsp.buf_request_sync(bufnr, 'workspace/executeCommand', params, 1000)
        end,
      })
    end
  end,
})

-- ESLint for auto-fixing
vim.lsp.config("eslint", {
  capabilities = capabilities,
  settings = {
    format = { enable = true },
    autoFixOnSave = true,
  },
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.code_action({
          context = {
            only = { 'source.fixAll.eslint' },
          },
          apply = true,
        })
      end,
    })
  end,
})

-- YAML Language Server
vim.lsp.config("yamlls", {
  capabilities = capabilities,
  settings = {
    yaml = {
      hover = true,
      validate = true,
      schemaStore = {
        enable = true,
      },
      completion = true,
      format = {
        enable = true,
        bracketSpacing = true,
        proseWrap = 'never',
        singleQuote = true,
      },
    },
  },
})

-- JSON Language Server
vim.lsp.config("jsonls", {
  capabilities = capabilities,
})

-- HTML Language Server
vim.lsp.config("html", {
  capabilities = capabilities,
})

-- CSS Language Server
vim.lsp.config("cssls", {
  capabilities = capabilities,
})

-- Python (Pyright)
vim.lsp.config("pyright", {
  capabilities = capabilities,
})

-- C# Language Server (disable Java as per config)
vim.lsp.config("csharp_ls", {
  capabilities = capabilities,
})

-- Bash Language Server
vim.lsp.config("bashls", {
  capabilities = capabilities,
})

-- Vim Language Server
vim.lsp.config("vimls", {
  capabilities = capabilities,
})

-- Markdown Language Server
vim.lsp.config("marksman", {
  capabilities = capabilities,
})

-- Docker Language Server
vim.lsp.config("dockerls", {
  capabilities = capabilities,
})

-- Emmet Language Server
vim.lsp.config("emmet_ls", {
  capabilities = capabilities,
  filetypes = {
    'html',
    'css',
    'scss',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
})
