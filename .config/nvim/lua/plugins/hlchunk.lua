require('hlchunk').setup({
  chunk = {
    enable = true,
    notify = true,
    exclude_filetypes = {
      alpha = true,
      fugitive = true,
    },
    use_treesitter = true,
    priority = 15,
    style = {
      { fg = Colors.cyan },
    },
    chars = {
      horizontal_line = '─',
      vertical_line = '│',
      left_top = '╭',
      left_bottom = '╰',
      right_arrow = '>',
    },
    textobject = '',
    max_file_size = 1024 * 1024,
    error_sign = true,
    duration = 150,
    delay = 200,
  },
})
