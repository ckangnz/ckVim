-- Git status
vim.keymap.set('n', '<leader>1', '<cmd>Git<cr><c-w>T', { desc = 'Git status in new tab' })

-- Git log
vim.keymap.set(
  'n',
  '<leader>2',
  ':GV --all<CR>',
  { silent = true, desc = 'Git log (all branches)' }
)
vim.keymap.set(
  'n',
  '<leader>@',
  ':FzfLua git_bcommits<CR>',
  { silent = true, desc = 'Git buffer commits' }
)
vim.keymap.set('v', '<leader>2', ':GV!<CR>', { silent = true, desc = 'Git log for selection' })

-- Git branches
vim.keymap.set('n', '<leader>3', function()
  if vim.fn.FugitiveHead() ~= '' then
    vim.cmd('FzfLua git_branches')
  else
    vim.notify('Not in a git repo', vim.log.levels.ERROR)
  end
end, { silent = true, desc = 'Git branches' })

-- Git commit
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', { silent = true, desc = 'Git commit' })

-- REPLACED WITH GITSIGNS
-- vim.keymap.set( 'n', '<leader>gr', ':Gread<CR>', { silent = true, desc = 'Git read (checkout file)' })
-- vim.keymap.set('n', '<leader>gw', ':Gwrite<CR>', { silent = true, desc = 'Git write (stage file)' })
-- vim.keymap.set('n', '<leader>gd', ':Gdiff<CR>', { silent = true, desc = 'Git diff' })
vim.keymap.set(
  'n',
  '<leader>gD',
  ':Gdiffsplit!<CR>',
  { silent = true, desc = 'Git diff split (3-way)' }
)

-- Git file operations
vim.keymap.set('n', '<leader>ge', ':Gedit<CR>', { silent = true, desc = 'Git edit' })
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { silent = true, desc = 'Git blame' })

-- Git push
vim.keymap.set(
  'n',
  '<leader>gp',
  ':AsyncRun Git push<CR>',
  { silent = true, desc = 'Git push current branch' }
)
vim.keymap.set(
  'n',
  '<leader>gP',
  ':AsyncRun Git push -f<CR>',
  { silent = true, desc = 'Git force push' }
)
vim.keymap.set('n', '<leader>gl', ':AsyncRun Git pull<CR>', { silent = true, desc = 'Git pull' })

-- Git-related autocommands
local git_group = vim.api.nvim_create_augroup('GitConfiguration', { clear = true })
-- Auto-delete fugitive buffers when hidden
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = 'fugitive://*',
  callback = function()
    vim.bo.bufhidden = 'delete'
  end,
  group = git_group,
  desc = 'Auto-delete fugitive buffers when hidden',
})
