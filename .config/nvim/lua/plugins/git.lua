vim.keymap.set('n', '<leader>1', '<cmd>Git<cr><c-w>T', { desc = 'Git status in new tab' })
vim.keymap.set(
  'n',
  '<leader>2',
  ':GV --all<CR>',
  { silent = true, desc = 'Git log (all branches)' }
)
vim.keymap.set(
  'n',
  '<leader>@',
  ':Telescope git_bcommits<CR>',
  { silent = true, desc = 'Git buffer commits' }
)
vim.keymap.set('v', '<leader>2', ':GV!<CR>', { silent = true, desc = 'Git log for selection' })

-- Git branches
vim.keymap.set('n', '<leader>3', function()
  if vim.fn.FugitiveHead() ~= '' then
    vim.cmd('Telescope git_branches')
  else
    vim.notify('Not in a git repo', vim.log.levels.ERROR)
  end
end, { silent = true, desc = 'Git branches' })

-- Git commit operations
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', { silent = true, desc = 'Git commit' })
vim.keymap.set(
  'n',
  '<leader>gr',
  ':Gread<CR>',
  { silent = true, desc = 'Git read (checkout file)' }
)
vim.keymap.set('n', '<leader>gw', ':Gwrite<CR>', { silent = true, desc = 'Git write (stage file)' })

-- Git diff operations
vim.keymap.set('n', '<leader>gd', ':Gdiff<CR>', { silent = true, desc = 'Git diff' })
vim.keymap.set(
  'n',
  '<leader>gD',
  ':Gdiffsplit!<CR>',
  { silent = true, desc = 'Git diff split (3-way)' }
)

-- Git file operations
vim.keymap.set('n', '<leader>ge', ':Gedit<CR>', { silent = true, desc = 'Git edit' })
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { silent = true, desc = 'Git blame' })

-- Git remote operations (using AsyncRun for non-blocking execution)
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

-- Git fetch operations
vim.keymap.set(
  'n',
  '<leader>gfo',
  ':AsyncRun Git fetch origin<CR>',
  { silent = true, desc = 'Git fetch origin' }
)
vim.keymap.set(
  'n',
  '<leader>gfa',
  ':AsyncRun Git fetch --all --prune<CR>',
  { silent = true, desc = 'Git fetch all with prune' }
)

-- Git status line helper function
local function update_git_status_line()
  if
    not vim.fn.exists('*FugitiveExtractGitDir') or vim.fn.exists('*FugitiveExtractGitDir') == 0
  then
    return ''
  end

  local dir = vim.b.git_dir or vim.fn.FugitiveExtractGitDir(vim.fn.resolve(vim.fn.expand('%:p')))
  if dir == '' then
    return ''
  end

  vim.b.git_dir = dir
end

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

-- Update git status line on various events
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'ShellCmdPost', 'BufWritePost' }, {
  callback = update_git_status_line,
  group = git_group,
  desc = 'Update git status line information',
})
