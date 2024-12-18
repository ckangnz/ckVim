--If nvim and not neovide

if vim.fn.has('nvim') and not vim.g.neovide then
  local smear_cursor = require('smear_cursor')

  smear_cursor.enabled = false
  smear_cursor.setup {
    normal_bg = nil,
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    use_floating_windows = true,
    legacy_computing_symbols_support = false,
    hide_target_hack = true,
  }
end
