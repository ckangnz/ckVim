-- vim-docker-tools configuration
-- Migrated from plugins/vim-docker-tools.vim

-- Docker integration tools

-- Keymaps
vim.keymap.set('n', '<leader>dc', ':DockerToolsToggle<cr>', {
  desc = 'Toggle Docker tools',
  silent = true
})
