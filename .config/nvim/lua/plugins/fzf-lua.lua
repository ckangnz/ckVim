local fzf = require('fzf-lua')
local actions = require('fzf-lua.actions')

-- Git repo detection (similar to your telescope setup)
local git_repo_cache = {}

vim.api.nvim_create_autocmd('DirChanged', {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname:match('^oil://') then
      return
    end
    git_repo_cache = {}
  end,
})

local function is_git_repo()
  local cwd = vim.fn.getcwd()
  if git_repo_cache[cwd] == nil then
    vim.fn.system('git -C "' .. cwd .. '" rev-parse --is-inside-work-tree')
    git_repo_cache[cwd] = vim.v.shell_error == 0
  end
  return git_repo_cache[cwd]
end

local function get_git_root()
  if not is_git_repo() then
    return vim.fn.getcwd()
  end
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    return vim.fn.getcwd()
  end
  return git_root
end

fzf.setup({
  'telescope',
  hls = {
    normal = 'Normal',
    title = 'Title',
    preview_normal = 'Normal',
    preview_border = 'FloatBorder',
    preview_title = 'Title',
    cursor = 'CursorLine',
    cursorline = 'CursorLine',
    search = 'Search',
    header = 'Question',
    spinner = 'Constant',
    info = 'Comment',
    prompt = 'Identifier',
  },
  winopts = {
    height = 0.85,
    width = 0.85,
    row = 0.35,
    col = 0.50,
    border = 'rounded',
    title_flags = false,
    treesitter = {
      enabled = true,
      fzf_colors = { ['hl'] = '-1:reverse', ['hl+'] = '-1:reverse' },
    },

    preview = {
      default = 'bat',
      border = 'rounded',
      wrap = 'nowrap',
      hidden = 'nohidden',
      vertical = 'down:45%',
      horizontal = 'right:60%',
      layout = 'flex',
      flip_columns = 120,
      scrollbar = 'float',
      delay = 100,
    },
  },
  fzf_opts = {
    ['--layout'] = 'reverse',
    ['--info'] = 'inline',
  },
  keymap = {
    builtin = true,
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
      ['ctrl-a'] = 'toggle-all',
      ['tab'] = 'toggle+down', -- Tab to multi-select
      ['shift-tab'] = 'toggle+up',
    },
  },
  files = {
    prompt = Icons.directory
      .. ' Find Files ['
      .. vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
      .. '] ❯ ',
    multiprocess = true,
    git_icons = false,
    file_icons = true,
    color_icons = true,
    find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
    rg_opts = [[--color=never --files --hidden --follow -g '!.git']],
    fd_opts = [[--color=never --type f --hidden --follow --exclude .git --exclude node_modules]],
    actions = {
      ['default'] = function(selected, opts)
        if #selected > 1 then
          actions.file_edit_or_qf(selected, opts)
        else
          actions.file_edit(selected, opts)
        end
      end,
      ['ctrl-s'] = actions.file_split,
      ['ctrl-v'] = actions.file_vsplit,
      ['ctrl-t'] = actions.file_tabedit,
    },
  },
  git = {
    files = {
      prompt = Icons.git .. ' Git Files [' .. vim.fn.fnamemodify(get_git_root(), ':~') .. '] ❯ ',
      cmd = 'git ls-files --exclude-standard',
      multiprocess = true,
      git_icons = true,
      file_icons = true,
      color_icons = true,
    },
    branches = {
      prompt = 'Branches ❯ ',
      cmd = 'git branch --all --color',
      preview = 'git log --graph --pretty=oneline --abbrev-commit --color {1}',
      remotes = 'local', -- "detach|local", switch behavior for remotes
      actions = {
        ['enter'] = actions.git_switch,
        ['ctrl-x'] = { fn = actions.git_branch_del, reload = true },
        ['ctrl-a'] = { fn = actions.git_branch_add, field_index = '{q}', reload = true },
      },
      cmd_add = { 'git', 'checkout', '-b' },
      cmd_del = { 'git', 'branch', '--delete' },
    },
  },
  grep = {
    prompt = Icons.magnify .. ' Live Grep [' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':~') .. '] > ',
    multiprocess = true,
    file_icons = true,
    color_icons = true,
    rg_opts = [[--column --line-number --no-heading --color=always --colors 'match:style:bold' --colors 'match:fg:yellow' --smart-case --hidden --max-columns=4096 -g '!.git' -e]],
    actions = {
      ['default'] = function(selected, opts)
        if #selected > 1 then
          actions.file_edit_or_qf(selected, opts)
        else
          actions.file_edit(selected, opts)
        end
      end,
      ['ctrl-s'] = actions.file_split,
      ['ctrl-v'] = actions.file_vsplit,
      ['ctrl-t'] = actions.file_tabedit,
    },
  },
  oldfiles = {
    prompt = Icons.directory .. ' Recent ❯ ',
    cwd_only = false,
    stat_file = true,
    include_current_session = true,
    actions = {
      ['default'] = actions.file_edit,
      ['ctrl-s'] = actions.file_split,
      ['ctrl-v'] = actions.file_vsplit,
      ['ctrl-t'] = actions.file_tabedit,
    },
  },
  buffers = {
    prompt = Icons.file_default .. ' Buffers ❯ ',
    file_icons = true,
    color_icons = true,
    sort_lastused = true,
    cwd = nil,
    sort_mru = true,
    actions = {
      ['default'] = actions.buf_edit,
      ['ctrl-s'] = actions.buf_split,
      ['ctrl-v'] = actions.buf_vsplit,
      ['ctrl-t'] = actions.buf_tabedit,
      ['ctrl-d'] = { fn = actions.buf_del, reload = true },
    },
  },
  diagnostics = {
    prompt = 'Diagnostics❯ ',
    cwd_only = false,
  },

  file_ignore_patterns = {
    '%.git/',
    'node_modules/',
    'plugged/',
    'autoload/',
    'build/',
    'dist/',
    'target/',
    'yarn%.lock',
    'package%-lock%.json',
    '%.plist',
  },
})

local function grep_visual_selection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})
  text = string.gsub(text, '\n', '')
  if text ~= '' then
    fzf.grep({
      search = text,
      prompt = Icons.magnify .. ' Visual Grep "' .. text:sub(1, 30) .. '" ❯ ',
    })
  end
end

vim.keymap.set('n', '<leader>T', fzf.builtin, { desc = 'FzfLua pickers' })
vim.keymap.set('n', '<C-p>', fzf.files, { desc = 'Find files (current dir)' })
vim.keymap.set('n', '<C-e>', fzf.oldfiles, { desc = 'Recent files' })
vim.keymap.set('n', '<leader>fG', fzf.git_files, { desc = 'Git files' })
vim.keymap.set('n', '<leader>ff', function()
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd())
  fzf.live_grep({ cwd })
end, { desc = 'Live grep (current dir)' })
vim.keymap.set('n', '<leader>fg', function()
  local git_root = get_git_root()
  fzf.live_grep({
    prompt = Icons.git .. ' Git Grep [' .. vim.fn.fnamemodify(git_root, ':~') .. '] ❯ ',
    cwd = git_root,
  })
end, { desc = 'Live grep from Git' })
vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = 'Resume last search' })
vim.keymap.set('v', '<leader>f', grep_visual_selection, { desc = 'Grep selection' })
vim.keymap.set('n', '<leader>F', fzf.grep_cword, { desc = 'Grep string under cursor' })

vim.keymap.set('n', '<leader>b', fzf.buffers, { desc = 'Switch buffers' })
vim.keymap.set('n', '<leader>q', fzf.quickfix, { desc = 'List quickfix items' })
vim.keymap.set('n', 'gh', fzf.help_tags, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>/', fzf.blines, { desc = 'Search in current buffer' })

vim.keymap.set('n', ']D', fzf.diagnostics_workspace, { desc = 'Workspace diagnostics' })
vim.keymap.set('n', 'grr', fzf.lsp_references, { desc = 'LSP references' })
vim.keymap.set('n', 'gi', fzf.lsp_implementations, { desc = 'LSP implementations' })
vim.keymap.set('n', 'gt', fzf.lsp_typedefs, { desc = 'LSP type definitions' })
vim.keymap.set('n', 'gO', fzf.lsp_document_symbols, { desc = 'LSP document symbols' })
vim.keymap.set('i', '<C-R><enter>', fzf.registers, { desc = 'Insert from registers' })
vim.api.nvim_create_user_command(
  'Registers',
  fzf.registers,
  { desc = 'Show registers with fzf-lua' }
)
