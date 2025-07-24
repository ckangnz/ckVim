local M = {}
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

-- Common LSP keymaps
local function setup_lsp_keymaps(bufnr)
  -- Navigation
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, silent = true, desc = 'Go to definition' })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, silent = true, desc = 'Go to declaration' })
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, silent = true, desc = 'Go to implementation' })
  vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { buffer = bufnr, silent = true, desc = 'Go to type definition' })
  vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr, silent = true, desc = 'References' })

  -- Documentation
  vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, { buffer = bufnr, silent = true, desc = 'Show documentation' })
  vim.keymap.set('n', '<C-k>', function() vim.lsp.buf.signature_help({ border = 'rounded' }) end, { buffer = bufnr, silent = true, desc = 'Signature help' })

  -- Code actions and refactoring
  vim.keymap.set('n', '<S-r>', vim.lsp.buf.rename, { buffer = bufnr, silent = true, desc = 'Rename symbol' })
  vim.keymap.set('n', 'ga.', vim.lsp.buf.code_action, { buffer = bufnr, silent = true, desc = 'Code action' })
  vim.keymap.set('v', 'ga', vim.lsp.buf.code_action, { buffer = bufnr, silent = true, desc = 'Code action for selection' })

  -- Formatting
  vim.keymap.set('n', '<leader>=', function()
    vim.lsp.buf.format({ async = true })
  end, { buffer = bufnr, silent = true, desc = 'Format document' })
  vim.keymap.set('v', '<leader>=', function()
    vim.lsp.buf.format({ async = true })
  end, { buffer = bufnr, silent = true, desc = 'Format selection' })

  -- Diagnostics
  vim.keymap.set('n', 'gan', function() vim.diagnostic.jump({ count = 1 }) end, { buffer = bufnr, silent = true, desc = 'Go to next diagnostic' })
  vim.keymap.set('n', 'gap', function() vim.diagnostic.jump({ count = -1 }) end, { buffer = bufnr, silent = true, desc = 'Go to previous diagnostic' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { buffer = bufnr, silent = true, desc = 'Diagnostics to loclist' })

  -- Telescope LSP integration
  vim.keymap.set('n', 'gs', '<cmd>Telescope lsp_document_symbols<cr>', { buffer = bufnr, silent = true, desc = 'Document symbols' })
  vim.keymap.set('n', 'gS', '<cmd>Telescope lsp_workspace_symbols<cr>', { buffer = bufnr, silent = true, desc = 'Workspace symbols' })
  -- Note: 'gc' is handled in telescope.lua for code actions (replaces old CoC commands)
  vim.keymap.set('n', 'gC', '<cmd>Telescope lsp_outgoing_calls<cr>', { buffer = bufnr, silent = true, desc = 'Outgoing calls' })
end

-- Common LSP capabilities (enhanced with nvim-cmp)
local function get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Add nvim-cmp capabilities
  local cmp_lsp = require('cmp_nvim_lsp')
  capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())

  -- Enhanced capabilities
  capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  }

  return capabilities
end

-- Common LSP on_attach function
local function on_attach(client, bufnr)
  -- Setup keymaps
  setup_lsp_keymaps(bufnr)

  -- Enable inlay hints if supported
  if client.supports_method('textDocument/inlayHint') and vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  -- Highlight symbol under cursor
  if client.supports_method('textDocument/documentHighlight') then
    local group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- Auto-format on save for specific filetypes
  local format_filetypes = {
    'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
    'lua', 'python', 'go', 'rust', 'json', 'yaml', 'markdown'
  }

  if vim.tbl_contains(format_filetypes, vim.bo[bufnr].filetype) and client.supports_method('textDocument/formatting') then
    local format_group = vim.api.nvim_create_augroup('lsp_format_on_save', { clear = false })
    vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = format_group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
      end,
    })
  end
end

-- LSP server configurations
local servers = {
  -- Lua
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = {
            '?.lua',
            '?/init.lua'
          }
        },
        diagnostics = {
          globals = { 'vim' },
          disable = { 'missing-fields' }
        },
        workspace = {
          library = {
            vim.env.VIMRUNTIME,
            "${3rd}/luv/library",
            "${3rd}/busted/library",
          },
          checkThirdParty = false,
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
        telemetry = { enable = false },
        completion = { callSnippet = 'Replace' },
        codeLens = { enable = true },
        hint = {
          enable = true,
          arrayIndex = "Disable",
        },
        format = {
          enable = true,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
          }
        },
      },
    },
  },

  -- TypeScript/JavaScript
  ts_ls = {
    settings = {
        typescript = {
          format = { enable = true },
          updateImportsOnFileMove = { enabled = 'always' },
          preferences = {
            includePackageJsonAutoImports = 'auto',
          },
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        format = { enable = true },
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  -- HTML
  html = {
    settings = {
      html = {
        format = { enable = true },
        hover = {
          documentation = true,
          references = true,
        },
      },
    },
  },

  -- CSS
  cssls = {
    settings = {
      css = {
        validate = true,
        lint = {
          unknownAtRules = 'ignore',
        },
      },
    },
  },

  -- JSON
  jsonls = {
    settings = {
      json = {
        -- schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  },

  -- YAML
  yamlls = {
    settings = {
      yaml = {
        hover = true,
        completion = true,
        validate = true,
        schemaStore = { enable = true, url = '' },
        -- schemas = require('schemastore').yaml.schemas(),
        format = {
          enable = true,
          bracketSpacing = true,
          proseWrap = 'never',
          singleQuote = true,
        },
      },
    },
  },

  -- Python
  pyright = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'workspace',
        },
      },
    },
  },

  -- Bash
  bashls = {},

  -- Vim
  vimls = {},

  -- Docker
  dockerls = {},

  -- Markdown
  marksman = {},

  -- C#
  csharp_ls = {
    settings = {
      csharp = {
        semanticHighlighting = { enabled = true },
      },
    },
  },
}

function M.setup_server(server_name)
  local server_config = servers[server_name] or {}
  local config = {
    on_attach = on_attach,
    capabilities = get_capabilities(),
  }
  config = vim.tbl_deep_extend('force', config, server_config)
  local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
  if not lspconfig_ok then
    vim.notify('lspconfig not available for ' .. server_name, vim.log.levels.WARN)
    return
  end
  lspconfig[server_name].setup(config)
end

function M.get_capabilities()
  return get_capabilities()
end

-- Commands
vim.api.nvim_create_user_command('LspInfo', vim.cmd.LspInfo, { desc = 'Show LSP information' })
vim.api.nvim_create_user_command('LspRestart', vim.cmd.LspRestart, { desc = 'Restart LSP servers' })
vim.api.nvim_create_user_command('LspLog', function() vim.cmd('edit ' .. vim.lsp.get_log_path()) end,
  { desc = 'Open LSP log' })

vim.api.nvim_create_user_command('Format', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Format current document' })

vim.api.nvim_create_user_command('OrganizeImports', function()
  local params = {
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf_request(0, 'workspace/executeCommand', params)
end, { desc = 'Organize imports (TypeScript)' })

return M
