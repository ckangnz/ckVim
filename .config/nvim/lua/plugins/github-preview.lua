if vim.fn.has('nvim') then
  require("github-preview").setup({
    host = "localhost",
    port = 6041,
    single_file = false,
    theme = {
      name = "system",
      high_contrast = true,
    },
    details_tags_open = true,
    cursor_line = {
      disable = false,
      color = "#89b482",
      opacity = 0.3,
    },
    scroll = {
      disable = false,
      top_offset_pct = 35,
    },
    log_level = nil,
  })
end
