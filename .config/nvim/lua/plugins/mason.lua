require('mason').setup({
  ui = {
    icons = {
      package_installed = Icons.check_default,
      package_pending = Icons.timer,
      package_uninstalled = Icons.error_slanted,
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
