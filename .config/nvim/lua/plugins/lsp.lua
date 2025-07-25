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

-- Get path to lspconfig plugin
local function get_lspconfig_path()
  local lazy_path = vim.fn.stdpath('data') .. '/lazy/nvim-lspconfig'
  if vim.fn.isdirectory(lazy_path) == 1 then
    return lazy_path
  end
  for _, path in ipairs(vim.split(vim.o.runtimepath, ',')) do
    if path:match('nvim%-lspconfig') then
      return path
    end
  end
  return nil
end

local function get_available_configs()
  local lspconfig_path = get_lspconfig_path()
  if not lspconfig_path then
    print('nvim-lspconfig not found')
    return {}
  end
  local lsp_dir = lspconfig_path .. '/lsp'
  if vim.fn.isdirectory(lsp_dir) == 0 then
    print('LSP configs directory not found: ' .. lsp_dir)
    return {}
  end
  local configs = {}
  local config_files = vim.fn.glob(lsp_dir .. '/*.lua', false, true)
  for _, file in ipairs(config_files) do
    local name = vim.fn.fnamemodify(file, ':t:r')
    local ok, config = pcall(dofile, file)
    if ok and type(config) == 'table' then
      configs[name] = config
    end
  end
  return configs
end

-- Get executable name from config
local function get_executable_from_config(config)
  if config.cmd and type(config.cmd) == 'table' and #config.cmd > 0 then
    return config.cmd[1]
  elseif config.cmd and type(config.cmd) == 'string' then
    return config.cmd
  end
  return nil
end

-- Async execution helper
local function run_async(cmd, callback)
  vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      if callback then
        callback(code == 0, code)
      end
    end,
    on_stdout = function(_, data)
      if data and #data > 0 then
        for _, line in ipairs(data) do
          if line ~= '' then
            print(line)
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        for _, line in ipairs(data) do
          if line ~= '' then
            print('Error: ' .. line)
          end
        end
      end
    end
  })
end

-- Get install command for a package manager
local function get_install_cmd(executable)
  -- Try to determine install method based on executable patterns
  if executable:match('language%-server') or executable:match('ls$') then
    -- Most language servers are npm packages
    return { 'npm', 'install', '-g', executable }
  elseif executable:match('pyright') or executable:match('typescript') then
    return { 'npm', 'install', '-g', executable }
  elseif executable:match('lua%-language%-server') then
    return { 'brew', 'install', 'lua-language-server' }
  elseif executable:match('marksman') then
    return { 'brew', 'install', 'marksman' }
  else
    -- Default to npm for unknown packages
    return { 'npm', 'install', '-g', executable }
  end
end

-- Get uninstall command
local function get_uninstall_cmd(executable)
  if executable:match('lua%-language%-server') or executable:match('marksman') then
    return { 'brew', 'uninstall', executable }
  else
    return { 'npm', 'uninstall', '-g', executable }
  end
end

-- Common LSP keymaps
local function setup_lsp_keymaps(bufnr)
  local opts = { buffer = bufnr, silent = true }

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
  vim.keymap.set('n', 'ga.', vim.lsp.buf.code_action, { buffer = bufnr, silent = true, desc = 'Code action' })
  vim.keymap.set('v', 'ga', vim.lsp.buf.code_action,
    { buffer = bufnr, silent = true, desc = 'Code action for selection' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,
    vim.tbl_extend('force', opts, { desc = 'Diagnostics to loclist' }))
end

-- Common on_attach function
local function on_attach(client, bufnr)
  setup_lsp_keymaps(bufnr)

  -- Disable inline inlay hints but show them in popup on cursor hover
  if client.supports_method('textDocument/inlayHint') and vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })

    -- Set up autocmd to show inlay hints in popup when cursor stops
    local hint_group = vim.api.nvim_create_augroup('lsp_inlay_hint_popup', { clear = false })
    vim.api.nvim_clear_autocmds({ group = hint_group, buffer = bufnr })

    vim.api.nvim_create_autocmd('CursorHold', {
      group = hint_group,
      buffer = bufnr,
      callback = function()
        local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
        local range = {
          start = params.position,
          ['end'] = { line = params.position.line, character = params.position.character + 1 }
        }

        client:request('textDocument/inlayHint', {
          textDocument = params.textDocument,
          range = range
        }, function(err, hints)
          if not err and hints and #hints > 0 then
            local hint_lines = {}
            for _, hint in ipairs(hints) do
              if hint.label then
                local label = type(hint.label) == 'string' and hint.label or
                    (hint.label[1] and hint.label[1].value or '')
                table.insert(hint_lines, '💡 ' .. label)
              end
            end

            if #hint_lines > 0 then
              -- Create floating window for hints
              local hint_buf = vim.api.nvim_create_buf(false, true)
              vim.api.nvim_buf_set_lines(hint_buf, 0, -1, false, hint_lines)

              -- Set buffer options
              vim.bo[hint_buf].buftype = 'nofile'
              vim.bo[hint_buf].bufhidden = 'wipe'

              local max_width = math.max(unpack(vim.tbl_map(function(line) return #line end, hint_lines)))
              local win_opts = {
                relative = 'cursor',
                width = math.min(max_width, 60),
                height = #hint_lines,
                row = 1,
                col = 0,
                style = 'minimal',
                border = 'rounded',
                title = ' Inlay Hints ',
                title_pos = 'center'
              }

              local win_id = vim.api.nvim_open_win(hint_buf, false, win_opts)

              -- Auto-close the window when cursor moves
              vim.api.nvim_create_autocmd('CursorMoved', {
                buffer = bufnr,
                once = true,
                callback = function()
                  if vim.api.nvim_win_is_valid(win_id) then
                    vim.api.nvim_win_close(win_id, true)
                  end
                end
              })

              -- Also close on insert mode
              vim.api.nvim_create_autocmd('InsertEnter', {
                buffer = bufnr,
                once = true,
                callback = function()
                  if vim.api.nvim_win_is_valid(win_id) then
                    vim.api.nvim_win_close(win_id, true)
                  end
                end
              })
            end
          end
        end)
      end
    })
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

  if client.supports_method('textDocument/formatting') then
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

-- Set up LspAttach autocmd
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      on_attach(client, args.buf)
    end
  end,
})

-- Load available configs and enable preferred servers
local available_configs = get_available_configs()
local preferred_servers = {
  'lua_ls', 'ts_ls', 'pyright', 'bashls', 'vimls', 'html', 'cssls',
  'jsonls', 'yamlls', 'emmet_ls', 'marksman', 'dockerls', 'autotools_ls'
}
-- Auto-enable servers that are installed
for _, server_name in ipairs(preferred_servers) do
  local config = available_configs[server_name]
  if config then
    local executable = get_executable_from_config(config)
    if executable and vim.fn.executable(executable) == 1 then
      local ok, err = pcall(function()
        vim.lsp.enable(server_name)
      end)

      if not ok then
        print('LSP: Failed to enable ' .. server_name .. ': ' .. tostring(err))
      end
    end
  end
end

-- Commands
vim.api.nvim_create_user_command('LspInfo', vim.cmd.LspInfo, { desc = 'Show LSP information' })
vim.api.nvim_create_user_command('LspRestart', vim.cmd.LspRestart, { desc = 'Restart LSP servers' })
vim.api.nvim_create_user_command('LspLog', function() vim.cmd('edit ' .. vim.lsp.get_log_path()) end,
  { desc = 'Open LSP log' })

-- Modern LSP Management Commands
vim.api.nvim_create_user_command('LspStart', function(opts)
  local server_name = opts.args
  if server_name == '' then
    print('Usage: :LspStart <server_name>')
    print('Available servers: ' .. table.concat(vim.tbl_keys(available_configs), ', '))
    return
  end

  local config = preferred_servers[server_name]
  if not config then
    print('Unknown server: ' .. server_name)
    print('Available: ' .. table.concat(vim.tbl_keys(available_configs), ', '))
    return
  end

  local executable = get_executable_from_config(config)
  if not executable then
    print('Could not determine executable for: ' .. server_name)
    return
  end

  if vim.fn.executable(executable) == 0 then
    print('Server not installed: ' .. server_name .. ' (executable: ' .. executable .. ')')
    print('Use :LspInstall ' .. server_name .. ' to install')
    return
  end

  local ok, err = pcall(function()
    vim.lsp.enable(server_name)
  end)

  if ok then
    print('Started LSP server: ' .. server_name)
  else
    print('Failed to start ' .. server_name .. ': ' .. tostring(err))
  end
end, {
  nargs = 1,
  desc = 'Start specific LSP server',
  complete = function()
    return vim.tbl_keys(available_configs)
  end
})

vim.api.nvim_create_user_command('LspStop', function(opts)
  local server_name = opts.args
  if server_name == '' then
    local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #buf_clients == 0 then
      print('No LSP servers active for current buffer')
      return
    end
    print('Usage: :LspStop <server_name>')
    print('Active servers for current buffer: ' .. table.concat(
      vim.tbl_map(function(client) return client.name end, buf_clients), ', '))
    return
  end

  local clients = vim.lsp.get_clients({ name = server_name })
  if #clients == 0 then
    print('No active clients found for: ' .. server_name)
    return
  end

  for _, client in ipairs(clients) do
    client:stop()
  end
  print('Stopped LSP server: ' .. server_name)
end, {
  nargs = 1,
  desc = 'Stop specific LSP server',
  complete = function()
    local active_clients = vim.lsp.get_clients()
    return vim.tbl_map(function(client) return client.name end, active_clients)
  end
})

vim.api.nvim_create_user_command('LspInstall', function(opts)
  local server_name = opts.args
  if server_name == '' then
    print('Usage: :LspInstall <server_name>')
    print('Available servers: ' .. table.concat(vim.tbl_keys(available_configs), ', '))
    return
  end

  local config = available_configs[server_name]
  if not config then
    print('Unknown server: ' .. server_name)
    return
  end

  local executable = get_executable_from_config(config)
  if not executable then
    print('Could not determine executable for: ' .. server_name)
    return
  end

  if vim.fn.executable(executable) == 1 then
    print('Server already installed: ' .. server_name .. ' (' .. executable .. ')')
    return
  end

  local install_cmd = get_install_cmd(executable)
  print('Installing ' .. server_name .. ' (' .. executable .. ')...')
  print('Command: ' .. table.concat(install_cmd, ' '))

  run_async(install_cmd, function(success, code)
    if success then
      print('Successfully installed ' .. server_name .. '!')
      print('Run :LspStart ' .. server_name .. ' to use it')
    else
      print('Failed to install ' .. server_name .. ' (exit code: ' .. code .. ')')
    end
  end)
end, {
  nargs = 1,
  desc = 'Install LSP server asynchronously',
  complete = function()
    return vim.tbl_keys(available_configs)
  end
})

vim.api.nvim_create_user_command('LspUninstall', function(opts)
  local server_name = opts.args
  if server_name == '' then
    print('Usage: :LspUninstall <server_name>')
    return
  end

  local config = preferred_servers[server_name]
  if not config then
    print('Unknown server: ' .. server_name)
    return
  end

  local executable = get_executable_from_config(config)
  if not executable then
    print('Could not determine executable for: ' .. server_name)
    return
  end

  local clients = vim.lsp.get_clients({ name = server_name })
  if #clients > 0 then
    for _, client in ipairs(clients) do
      client:stop()
    end
    print('Stopped running server: ' .. server_name)
  end

  if vim.fn.executable(executable) == 0 then
    print('Server not installed: ' .. server_name)
    return
  end

  local uninstall_cmd = get_uninstall_cmd(executable)
  print('Uninstalling ' .. server_name .. ' (' .. executable .. ')...')
  print('Command: ' .. table.concat(uninstall_cmd, ' '))

  run_async(uninstall_cmd, function(success, code)
    if success then
      print('Successfully uninstalled ' .. server_name .. '!')
    else
      print('Failed to uninstall ' .. server_name .. ' (exit code: ' .. code .. ')')
    end
  end)
end, {
  nargs = 1,
  desc = 'Uninstall LSP server asynchronously',
  complete = function()
    return vim.tbl_keys(available_configs)
  end
})

vim.api.nvim_create_user_command('LspUpdate', function(opts)
  local server_name = opts.args

  if server_name == '' then
    -- Update all installed servers
    print('Updating all installed LSP servers...')
    local installed_servers = {}

    for name, config in pairs(available_configs) do
      local executable = get_executable_from_config(config)
      if executable and vim.fn.executable(executable) == 1 then
        table.insert(installed_servers, { name = name, executable = executable })
      end
    end

    if #installed_servers == 0 then
      print('No LSP servers installed')
      return
    end

    -- Group by package manager and update
    local npm_packages = {}
    local brew_packages = {}

    for _, server in ipairs(installed_servers) do
      if server.executable:match('lua%-language%-server') or server.executable:match('marksman') then
        table.insert(brew_packages, server.executable)
      else
        table.insert(npm_packages, server.executable)
      end
    end

    if #npm_packages > 0 then
      print('Updating npm packages: ' .. table.concat(npm_packages, ', '))
      run_async({ 'npm', 'update', '-g', unpack(npm_packages) }, function(success)
        if success then
          print('NPM packages updated successfully!')
        else
          print('Failed to update some NPM packages')
        end
      end)
    end

    if #brew_packages > 0 then
      print('Updating brew packages: ' .. table.concat(brew_packages, ', '))
      run_async({ 'brew', 'upgrade', unpack(brew_packages) }, function(success)
        if success then
          print('Brew packages updated successfully!')
        else
          print('Failed to update some brew packages')
        end
      end)
    end
  else
    -- Update specific server
    local config = available_configs[server_name]
    if not config then
      print('Unknown server: ' .. server_name)
      return
    end

    local executable = get_executable_from_config(config)
    if not executable then
      print('Could not determine executable for: ' .. server_name)
      return
    end

    if vim.fn.executable(executable) == 0 then
      print('Server not installed: ' .. server_name)
      return
    end

    local update_cmd
    if executable:match('lua%-language%-server') or executable:match('marksman') then
      update_cmd = { 'brew', 'upgrade', executable }
    else
      update_cmd = { 'npm', 'update', '-g', executable }
    end

    print('Updating ' .. server_name .. ' (' .. executable .. ')...')
    print('Command: ' .. table.concat(update_cmd, ' '))

    run_async(update_cmd, function(success, code)
      if success then
        print('Successfully updated ' .. server_name .. '!')
        print('Run :LspRestart to use the updated version')
      else
        print('Failed to update ' .. server_name .. ' (exit code: ' .. code .. ')')
      end
    end)
  end
end, {
  nargs = '?',
  desc = 'Update LSP server(s) asynchronously',
  complete = function()
    return vim.tbl_keys(available_configs)
  end
})

vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format({ async = true }) end,
  { desc = 'Format current document' })

vim.api.nvim_create_user_command('OrganizeImports', function()
  local params = {
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf_request(0, 'workspace/executeCommand', params)
end, { desc = 'Organize imports (TypeScript)' })
