-- Git Browse - Based on snacks.nvim gitbrowse implementation
-- Patterns to transform git remotes to HTTPS URLs
local remote_patterns = {
  { '^(https?://.*)%.git$', '%1' },
  { '^git@(.+):(.+)%.git$', 'https://%1/%2' },
  { '^git@(.+):(.+)$', 'https://%1/%2' },
  { '^git@(.+)/(.+)$', 'https://%1/%2' },
  { '^org%-(%d+)@(.+):(.+)%.git$', 'https://%2/%3' },
  { '^ssh://git@(.*)$', 'https://%1' },
  { '^ssh://([^:/]+)(:%d+)/(.*)$', 'https://%1/%3' },
  { '^ssh://([^/]+)/(.*)$', 'https://%1/%2' },
  { 'ssh%.dev%.azure%.com/v3/(.*)/(.*)$', 'dev.azure.com/%1/_git/%2' },
  { '^https://%w*@(.*)', 'https://%1' },
  { '^git@(.*)', 'https://%1' },
  { ':%d+', '' },
  { '%.git$', '' },
}

-- URL patterns for different git providers
local url_patterns = {
  ['github%.com'] = {
    repo = '',
    branch = '/tree/{branch}',
    file = '/blob/{branch}/{file}#L{line_start}-L{line_end}',
    commit = '/commit/{commit}',
    issues = '/issues',
    pulls = '/pulls',
    pull = '/pull/{branch}',
  },
  ['gitlab%.com'] = {
    repo = '',
    branch = '/-/tree/{branch}',
    file = '/-/blob/{branch}/{file}#L{line_start}-{line_end}',
    commit = '/-/commit/{commit}',
    issues = '/-/issues',
    pulls = '/-/merge_requests',
  },
  ['bitbucket%.org'] = {
    repo = '',
    branch = '/src/{branch}',
    file = '/src/{branch}/{file}#lines-{line_start}:{line_end}',
    commit = '/commits/{commit}',
    issues = '/issues',
    pulls = '/pull-requests',
    pull = '/pull-requests/new?source={branch}',
  },
}

local function get_repo_url(remote)
  local url = remote
  for _, pattern in ipairs(remote_patterns) do
    url = url:gsub(pattern[1], pattern[2])
  end
  return url:find('https://') == 1 and url or ('https://%s'):format(url)
end

local function get_provider_patterns(repo_url)
  for pattern, urls in pairs(url_patterns) do
    if repo_url:find(pattern) then
      return urls
    end
  end
  return nil
end

local function git_command(args, cwd)
  local cmd = vim.list_extend({ 'git', '-C', cwd or vim.fn.getcwd() }, args)
  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return nil, result
  end
  return vim.trim(result)
end

local function build_url(template, fields)
  return template:gsub('(%b{})', function(key)
    return fields[key:sub(2, -2)] or key
  end)
end

local function find_bitbucket_pr(repo_url, branch)
  local workspace, repo_slug = repo_url:match('bitbucket%.org/([^/]+)/([^/]+)$')
  if not workspace or not repo_slug then
    return nil
  end

  local api_url = string.format(
    'https://api.bitbucket.org/2.0/repositories/%s/%s/pullrequests?q=source.branch.name="%s"+AND+state="OPEN"',
    workspace,
    repo_slug,
    branch
  )

  local response = vim.fn.system({ 'curl', '-s', api_url })
  if vim.v.shell_error ~= 0 then
    return nil
  end

  local ok, json = pcall(vim.json.decode, response)
  if not ok or not json or not json.values or #json.values == 0 then
    return nil
  end

  return json.values[1].id
end

local function git_browse(what)
  local file = vim.api.nvim_buf_get_name(0)
  local cwd = file ~= '' and vim.fn.fnamemodify(file, ':h') or vim.fn.getcwd()

  local branch, err = git_command({ 'rev-parse', '--abbrev-ref', 'HEAD' }, cwd)
  if not branch then
    vim.notify('Not in a git repository', vim.log.levels.ERROR)
    return
  end

  local remote, _ = git_command({ 'config', '--get', 'remote.origin.url' }, cwd)
  if not remote then
    vim.notify('No git remote found', vim.log.levels.ERROR)
    return
  end

  local repo_url = get_repo_url(remote)
  local patterns = get_provider_patterns(repo_url)

  if not patterns then
    vim.notify('Unsupported git provider', vim.log.levels.WARN)
    vim.ui.open(repo_url)
    return
  end

  local fields = { branch = branch }

  if what == 'file' and file ~= '' then
    local rel_file, _ = git_command({ 'ls-files', '--full-name', file }, cwd)
    if rel_file then
      fields.file = rel_file
      local line_start = vim.fn.line('.')
      local line_end = line_start

      -- Check for visual selection
      if vim.fn.mode():find('[vV]') then
        vim.cmd('normal! ')
        line_start = vim.api.nvim_buf_get_mark(0, '<')[1]
        line_end = vim.api.nvim_buf_get_mark(0, '>')[1]
        if line_start > line_end then
          line_start, line_end = line_end, line_start
        end
      end

      fields.line_start = line_start
      fields.line_end = line_end
    else
      vim.notify('File not tracked by git', vim.log.levels.WARN)
      return
    end
  end

  if what == 'commit' then
    local word = vim.fn.expand('<cword>')
    if word:match('^[a-fA-F0-9]+$') and #word >= 7 then
      fields.commit = word
    else
      vim.notify('No commit hash under cursor', vim.log.levels.WARN)
      return
    end
  end

  if what == 'pull' and repo_url:find('bitbucket%.org') then
    local pr_id = find_bitbucket_pr(repo_url, branch)
    if pr_id then
      local url = repo_url .. '/pull-requests/' .. pr_id
      vim.notify('Opening PR #' .. pr_id .. ': ' .. url, vim.log.levels.INFO)
      vim.ui.open(url)
      return
    end
  end

  -- Build and open URL
  local pattern = patterns[what]
  if not pattern then
    vim.notify('Action "' .. what .. '" not supported for this provider', vim.log.levels.WARN)
    return
  end

  local url = repo_url .. build_url(pattern, fields)
  vim.notify('Opening: ' .. url, vim.log.levels.INFO)
  vim.ui.open(url)
end

-- Git browse keymaps
vim.keymap.set('n', ',gog', function()
  git_browse('repo')
end, { desc = 'Open git repo in browser' })

vim.keymap.set({ 'n', 'v' }, ',gof', function()
  git_browse('file')
end, { desc = 'Open current file in browser' })

vim.keymap.set('n', ',goi', function()
  git_browse('issues')
end, { desc = 'Open repo issues' })

vim.keymap.set('n', ',gor', function()
  git_browse('pull')
end, { desc = 'Open PR for current branch' })

vim.keymap.set('n', ',gop', function()
  git_browse('pulls')
end, { desc = 'Open pull requests' })

vim.keymap.set('n', ',goc', function()
  git_browse('commit')
end, { desc = 'Open commit under cursor' })

vim.keymap.set('n', ',gob', function()
  git_browse('branch')
end, { desc = 'Open current branch' })
