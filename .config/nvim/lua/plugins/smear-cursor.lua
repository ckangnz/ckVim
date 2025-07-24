if not vim.g.neovide then
  local smear_cursor = require('smear_cursor')

  smear_cursor.enabled = true
  smear_cursor.setup({
    normal_bg = nil,
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    use_floating_windows = true,
    scroll_buffer_space = true,
    legacy_computing_symbols_support = false,
    hide_target_hack = true,
    smear_insert_mode = true,
  })
end
