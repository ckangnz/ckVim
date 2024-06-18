vim.keymap.set('n', '<leader>h', '<cmd>lua require("spectre").toggle({ path = "**/*" })<CR>', {
  desc = "Toggle Spectre"
})
vim.keymap.set('v', '<leader>h', '<esc><cmd>lua require("spectre").open_visual({ path = "**/*" })<CR>', {
  desc = "Search current word"
})
