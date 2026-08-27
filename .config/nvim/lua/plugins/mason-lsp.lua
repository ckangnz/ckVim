require('mason-lspconfig').setup({
  ensure_installed = {
    'vimls',
    'lua_ls',
    'bashls',
    'marksman',

    'html',
    'cssls',
    'tsc',
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

vim.lsp.config('tsc', {
  capabilities = lsp_capabilities,
  cmd = function(dispatchers, config)
    local mason_tsc = vim.fs.joinpath(vim.fn.stdpath('data'), 'mason', 'bin', 'tsc')
    local tsc = mason_tsc

    local function read_package(package_path)
      if vim.fn.filereadable(package_path) ~= 1 then
        return
      end

      local ok, package = pcall(vim.json.decode, table.concat(vim.fn.readfile(package_path), '\n'))
      return ok and package or nil
    end

    local package_names = { 'typescript' }
    local root_package = read_package(vim.fs.joinpath(config.root_dir, 'package.json'))

    if root_package then
      for _, dependency_type in ipairs({ 'dependencies', 'devDependencies', 'optionalDependencies' }) do
        for package_name, version in pairs(root_package[dependency_type] or {}) do
          if type(version) == 'string' and vim.startswith(version, 'npm:typescript@') then
            table.insert(package_names, package_name)
          end
        end
      end
    end

    table.sort(package_names, function(first, second)
      return first ~= 'typescript' and (second == 'typescript' or first < second)
    end)

    for _, package_name in ipairs(package_names) do
      local package_path = vim.fs.joinpath(config.root_dir, 'node_modules', package_name, 'package.json')
      local package = read_package(package_path)
      local version = package and package.version or ''
      local major_version = tonumber(version:match('^(%d+)'))
      local local_tsc = vim.fs.joinpath(config.root_dir, 'node_modules', package_name, 'bin', 'tsc')

      if major_version and major_version >= 7 and vim.fn.executable(local_tsc) == 1 then
        tsc = local_tsc
        break
      end
    end

    return vim.lsp.rpc.start({ tsc, '--lsp', '--stdio' }, dispatchers)
  end,
  on_attach = function(client, bufnr)
    vim.api.nvim_create_user_command('OrganizeImports', function()
      vim.lsp.buf.execute_command({
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

vim.lsp.enable('tsc')

vim.lsp.config('eslint', {
  capabilities = lsp_capabilities,
  settings = {
    eslint = {
      format = { enable = true },
    },
    workingDirectory = { mode = 'auto' },
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
  end,
})

vim.api.nvim_create_user_command('LspInfo', function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })

  if #clients == 0 then
    vim.notify('No LSP clients attached to this buffer.', vim.log.levels.INFO, { title = 'LSP clients' })
    return
  end

  local client_info = vim.tbl_map(function(client)
    return string.format('%s (root: %s)', client.name, client.config.root_dir or 'none')
  end, clients)

  vim.notify(table.concat(client_info, '\n'), vim.log.levels.INFO, { title = 'LSP clients' })
end, { desc = 'Show LSP clients attached to the current buffer' })
