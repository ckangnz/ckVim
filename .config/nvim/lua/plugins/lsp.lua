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
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
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
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  root_markers = { 'package.json', 'tsconfig.json', '.git' },
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
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
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
  filetypes = { 'yaml', 'yml' },
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
  filetypes = { 'json' },
  capabilities = capabilities,
})

-- HTML Language Server
vim.lsp.config("html", {
  capabilities = capabilities,
  filetypes = { 'html' },
})

-- CSS Language Server
vim.lsp.config("cssls", {
  capabilities = capabilities,
  filetypes = { 'css', 'scss', 'sass' },
})

-- Python (Pyright)
vim.lsp.config("pyright", {
  capabilities = capabilities,
  filetypes = { 'python' },
})

-- C# Language Server
vim.lsp.config("csharp_ls", {
  capabilities = capabilities,
  filetypes = { 'cs' },
})

-- Bash Language Server
vim.lsp.config("bashls", {
  filetypes = { "zsh", "bash", "sh" },
  capabilities = capabilities,
})

-- Vim Language Server
vim.lsp.config("vimls", {
  capabilities = capabilities,
  filetypes = { 'vim' },
})

-- Markdown Language Server
vim.lsp.config("marksman", {
  filetypes = { "markdown", "md" },
  capabilities = capabilities,
})

-- Docker Language Server
vim.lsp.config("dockerls", {
  filetypes = { 'dockerfile' },
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

-- Auto-start LSP servers when opening files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  callback = function(ev)
    vim.defer_fn(function()
      local ft = vim.bo[ev.buf].filetype
      local server_map = {
        typescript = 'ts_ls',
        typescriptreact = 'ts_ls',
        javascript = 'ts_ls',
        javascriptreact = 'ts_ls',
        lua = 'lua_ls',
        markdown = 'marksman',
        md = 'marksman',
        json = 'jsonls',
        yaml = 'yamlls',
        yml = 'yamlls',
        sh = 'bashls',
        zsh = 'bashls',
        bash = 'bashls',
        dockerfile = 'dockerls',
        html = 'html',
        css = 'cssls',
        scss = 'cssls',
        sass = 'cssls',
        python = 'pyright',
        cs = 'csharp_ls',
        vim = 'vimls'
      }

      local server = server_map[ft]
      if server then
        local clients = vim.lsp.get_clients({ bufnr = ev.buf })
        if not vim.tbl_contains(vim.tbl_map(function(c) return c.name end, clients), server) then
          pcall(vim.cmd, 'LspStart ' .. server)
        end
      end
    end, 100)
  end,
})
