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
  automatic_installation = false,  -- Disable automatic installation on startup
  handlers = {
    function(server_name)
      require('plugins.lsp').setup_server(server_name)
    end,
  },
})

-- Defer automatic installation to after startup
vim.defer_fn(function()
  mason_lspconfig.setup({
    ensure_installed = ensure_installed_servers,
    automatic_installation = true,
  })
end, 1000)  -- Delay by 1 second

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
