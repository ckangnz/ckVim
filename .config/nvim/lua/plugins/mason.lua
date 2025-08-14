require('mason').setup({
  ui = {
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
    keymaps = {
      apply_language_filter = '/',
    },
    check_outdated_packages_on_open = true,
    border = nil,
    width = 0.4,
    height = 0.5,
  },
})
