local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')

-- Mason setup
mason.setup({
  ui = {
    border = 'rounded',
    width = 0.8,
    height = 0.8,
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    },
  },
  install_root_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "mason"),
  log_level = vim.log.levels.WARN,  -- Reduce logging for performance
  max_concurrent_installers = 8,   -- Increase concurrent installers
  github = {
    -- Reduce GitHub API calls during startup
    download_url_template = 'https://github.com/%s/releases/download/%s/%s',
  },
})

-- LSP servers to install automatically
local ensure_installed_servers = {
  -- Core languages
  'vimls',
  'lua_ls',
  'bashls',

  -- Web development
  'emmet_ls',
  'html',
  'cssls',
  'ts_ls',
  'jsonls',
  'yamlls',

  -- Documentation
  'marksman', -- Markdown

  -- Compiled languages
  'csharp_ls',     -- C#
  'pyright',       -- Python
  'jdtls',         -- Java
  'kotlin_language_server', -- Kotlin

  -- Mobile development
  -- 'dartls',        -- Dart/Flutter

  -- Infrastructure
  'dockerls',
  -- 'terraform_lsp',
}

-- Additional tools (formatters, linters, debuggers)
local ensure_installed_tools = {
  -- Formatters
  'prettier',
  'stylua',
  'black',
  'isort',
  'shfmt',
  'dart-debug-adapter', -- Dart/Flutter formatter

  -- Linters
  'eslint_d',
  'pylint',
  'shellcheck',
  'hadolint', -- Dockerfile linter
  'yamllint',
  'markdownlint',

  -- Debuggers
  'node-debug2-adapter',
  'chrome-debug-adapter',
  'debugpy', -- Python debugger
  'java-debug-adapter', -- Java debugger
  'java-test', -- Java testing
}

mason_lspconfig.setup({
  ensure_installed = ensure_installed_servers,
  automatic_installation = true,
  handlers = {
    function(server_name)
      -- Ensure lspconfig is properly loaded before setting up servers
      local lspconfig_ok, _ = pcall(require, 'lspconfig')
      if not lspconfig_ok then
        vim.notify('lspconfig not available, retrying in 100ms...', vim.log.levels.WARN)
        vim.defer_fn(function()
          require('plugins.lsp').setup_server(server_name)
        end, 100)
        return
      end
      require('plugins.lsp').setup_server(server_name)
    end,
  },
})

vim.api.nvim_create_user_command('Mason', function()
  require('mason.ui').open()
end, { desc = 'Open Mason UI' })

vim.api.nvim_create_user_command('MasonUpdate', function()
  vim.cmd({ cmd = 'MasonUpdate' })
end, { desc = 'Update all Mason packages' })

vim.api.nvim_create_user_command('MasonInstall', function(opts)
  vim.cmd({ cmd = 'MasonInstall', args = { opts.args } })
end, { nargs = 1, desc = 'Install Mason package' })

vim.api.nvim_create_user_command('MasonUninstall', function(opts)
  vim.cmd({ cmd = 'MasonUninstall', args = { opts.args } })
end, { nargs = 1, desc = 'Uninstall Mason package' })

-- Fixed keymap to use the proper Mason UI function
vim.keymap.set('n', '<leader>pm', function()
  require('mason.ui').open()
end, { desc = 'Open Mason' })
