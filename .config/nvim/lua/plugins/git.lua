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

-- Git commit
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', { silent = true, desc = 'Git commit' })
vim.keymap.set(
  'n',
  '<leader>gr',
  ':Gread<CR>',
  { silent = true, desc = 'Git read (checkout file)' }
)
vim.keymap.set('n', '<leader>gw', ':Gwrite<CR>', { silent = true, desc = 'Git write (stage file)' })

-- Git diff
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

local function convert_ssh_to_https_url(url)
  if url:match('^git@github%.com:') then
    return url:gsub('^git@github%.com:', 'https://github.com/')
  elseif url:match('^git@bitbucket%.org:') then
    return url:gsub('^git@bitbucket%.org:', 'https://bitbucket.org/')
  end
  return url
end

local function get_repo_https_url()
  local remote_url = vim.fn.system('git config --get remote.origin.url'):gsub('\n', '')

  if remote_url == '' then
    return nil
  end

  remote_url = convert_ssh_to_https_url(remote_url)
  remote_url = remote_url:gsub('%.git$', '')
  return remote_url
end

local function get_git_provider()
  local url = get_repo_https_url()
  if not url then
    return nil
  end

  if url:match('^https://github%.com/') then
    return 'github'
  elseif url:match('^https://bitbucket%.org/') then
    return 'bitbucket'
  else
    return 'unknown'
  end
end

local function get_relative_file_path()
  local current_file = vim.fn.expand('%:p')
  local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')

  if current_file == '' or git_root == '' then
    return nil
  end

  local relative_path = current_file:gsub('^' .. vim.pesc(git_root) .. '/', '')
  return relative_path
end

local function with_https_remote_for_github(callback)
  local provider = get_git_provider()
  if provider ~= 'github' then
    vim.notify('GBrowse only works with GitHub repositories', vim.log.levels.ERROR)
    return
  end

  local original_url = vim.fn.system('git config --get remote.origin.url'):gsub('\n', '')
  local https_url = get_repo_https_url()

  if original_url:match('^git@github%.com:') then
    vim.fn.system('git config --local remote.origin.url "' .. https_url .. '"')

    local success, err = pcall(callback)
    vim.fn.system('git config --local remote.origin.url "' .. original_url .. '"')

    if not success then
      vim.notify('Error executing GitHub browse: ' .. tostring(err), vim.log.levels.ERROR)
    end
  else
    callback()
  end
end

local function browse_project()
  local provider = get_git_provider()
  local repo_url = get_repo_https_url()

  if not repo_url then
    vim.notify('Could not determine repository URL', vim.log.levels.ERROR)
    return
  end

  if provider == 'github' then
    with_https_remote_for_github(function()
      vim.cmd('GBrowse!')
    end)
  else
    vim.fn.system('open "' .. repo_url .. '"')
  end
end

local function browse_file()
  local provider = get_git_provider()
  local repo_url = get_repo_https_url()
  local relative_path = get_relative_file_path()

  if not repo_url then
    vim.notify('Could not determine repository URL', vim.log.levels.ERROR)
    return
  end

  if provider == 'github' then
    with_https_remote_for_github(function()
      vim.cmd('GBrowse')
    end)
  elseif provider == 'bitbucket' and relative_path then
    local branch = vim.fn['FugitiveHead']()
    local line_number = vim.fn.line('.')
    local url = repo_url .. '/src/' .. (branch ~= '' and branch or 'master') .. '/' .. relative_path
    if line_number > 0 then
      url = url .. '#lines-' .. line_number
    end
    vim.fn.system('open "' .. url .. '"')
  else
    vim.notify('File browsing not supported for this Git provider', vim.log.levels.WARN)
  end
end

local function browse_issues()
  local provider = get_git_provider()
  local repo_url = get_repo_https_url()

  if not repo_url then
    vim.notify('Could not determine repository URL', vim.log.levels.ERROR)
    return
  end

  local issues_url
  if provider == 'github' then
    issues_url = repo_url .. '/issues'
  elseif provider == 'bitbucket' then
    issues_url = repo_url .. '/issues'
  else
    vim.notify('Issues browsing not supported for this Git provider', vim.log.levels.WARN)
    return
  end

  vim.fn.system('open "' .. issues_url .. '"')
end

-- Helper function to URL encode strings
local function url_encode(str)
  if str then
    str = str:gsub('([^%w _~%.%-])', function(c)
      return ('%%%02X'):format(c:byte())
    end)
    str = str:gsub(' ', '+')
  end
  return str
end

local function browse_current_branch_pr()
  local provider = get_git_provider()
  local repo_url = get_repo_https_url()
  local branch = vim.fn['FugitiveHead']()

  if not repo_url then
    vim.notify('Could not determine repository URL', vim.log.levels.ERROR)
    return
  end

  if branch == '' then
    vim.notify('Not on a git branch', vim.log.levels.ERROR)
    return
  end

  local encoded_branch = url_encode(branch)
  local pr_url

  if provider == 'github' then
    -- GitHub: Search for PRs where the head branch matches
    pr_url = repo_url .. '/pull/' .. encoded_branch
  elseif provider == 'bitbucket' then
    pr_url = repo_url .. '/pull-requests/new?source=' .. encoded_branch
  else
    vim.notify('Pull request browsing not supported for this Git provider', vim.log.levels.WARN)
    return
  end

  vim.fn.system('open "' .. pr_url .. '"')
end

local function browse_pull_requests()
  local provider = get_git_provider()
  local repo_url = get_repo_https_url()

  if not repo_url then
    vim.notify('Could not determine repository URL', vim.log.levels.ERROR)
    return
  end

  local pr_url
  if provider == 'github' then
    pr_url = repo_url .. '/pulls'
  elseif provider == 'bitbucket' then
    pr_url = repo_url .. '/pull-requests'
  else
    vim.notify('Pull requests browsing not supported for this Git provider', vim.log.levels.WARN)
    return
  end

  vim.fn.system('open "' .. pr_url .. '"')
end

-- GitHub browsing keymaps
vim.keymap.set('n', ',gog', browse_project, { desc = 'Open GitHub project' })
vim.keymap.set('n', ',gof', browse_file, { desc = 'Open current file on GitHub' })
vim.keymap.set('n', ',goi', browse_issues, { desc = 'Open GitHub issues' })
vim.keymap.set('n', ',gor', browse_current_branch_pr, { desc = 'Open current branch PR' })
vim.keymap.set('n', ',gop', browse_pull_requests, { desc = 'Open GitHub pull requests' })

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
