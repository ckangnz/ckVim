if vim.fn.has('nvim') then
  require("github-preview").setup({
    host = "localhost",
    port = 6041,
    single_file = false,
    theme = {
      name = "dark",
      high_contrast = false,
    },
    details_tags_open = true,
    cursor_line = {
      disable = true,
    },
    scroll = {
      disable = false,
      top_offset_pct = 35,
    },
    log_level = nil,
  })
end
