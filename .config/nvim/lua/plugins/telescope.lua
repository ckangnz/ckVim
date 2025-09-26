local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local state = require('telescope.actions.state')

-- Multi-selection helper function
local select_one_or_multi = function(prompt_bufnr)
  local multi = state.get_current_picker(prompt_bufnr):get_multi_selection()
  if not vim.tbl_isempty(multi) then
    actions.send_selected_to_qflist(prompt_bufnr)
    actions.open_qflist()
  else
    actions.select_default(prompt_bufnr)
  end
end

telescope.setup({
  defaults = {
    initial_mode = 'insert',
    winblend = 0,
    layout_config = { prompt_position = 'top' },
    path_display = { 'smart' },
    sorting_strategy = 'ascending',
    cache_picker = {
      num_pickers = 10,
    },
    dynamic_preview_title = false,
    results_title = false,
    mappings = {
      i = {
        ['<CR>'] = select_one_or_multi,
        ['<C-n>'] = actions.move_selection_next,
        ['<C-p>'] = actions.move_selection_previous,
        ['<C-j>'] = 'preview_scrolling_down',
        ['<C-k>'] = 'preview_scrolling_up',
        ['<C-d>'] = false, -- Disable preview scroll down
        ['<C-u>'] = false, -- Disable preview scroll up
        ['<C-h>'] = 'preview_scrolling_left',
        ['<C-l>'] = 'preview_scrolling_right',
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<C-/>'] = 'which_key',
        ['<LeftMouse>'] = {
          actions.mouse_click,
          type = 'action',
          opts = { expr = true },
        },
        ['<2-LeftMouse>'] = {
          actions.double_mouse_click,
          type = 'action',
          opts = { expr = true },
        },
      },
    },
    find_command = {
      'fd',
      '--hidden',
      '--type=f',
      '--strip-cwd-prefix',
      '--exclude=.git',
      '--exclude=node_modules',
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--trim',
      '--hidden',
    },
    file_ignore_patterns = {
      '^.git/',
      'node_modules/',
      'plugged/',
      'autoload/',
      'target/',
      'build/',
      'dist/',
      'yarn%.lock',
      'package%-lock%.json',
      '%.plist',
      '%.tsx%.html$',
    },
    preview = {
      timeout = 200,
      filesize_limit = 25,
      mime_hook = function(filepath, bufnr, opts)
        local is_image = function()
          local image_extensions = { 'png', 'jpg', 'jpeg' }
          local split_path = vim.split(filepath:lower(), '.', { plain = true })
          local extension = split_path[#split_path]
          return vim.tbl_contains(image_extensions, extension)
        end
        if is_image() then
          local term = vim.api.nvim_open_term(bufnr, {})
          local function send_output(_, data, _)
            for _, d in ipairs(data) do
              vim.api.nvim_chan_send(term, d .. '\r\n')
            end
          end
          vim.fn.jobstart(
            { 'catimg', filepath },
            { on_stdout = send_output, stdout_buffered = true, pty = true }
          )
        else
          require('telescope.previewers.utils').set_preview_message(
            bufnr,
            opts.winid,
            'Binary cannot be previewed'
          )
        end
      end,
    },
  },
  pickers = {
    find_files = {
      prompt_prefix = Icons.directory,
      find_command = { 'fd', '--type=f', '--strip-cwd-prefix' },
    },
    oldfiles = {
      prompt_prefix = Icons.directory,
      only_cwd = true, -- Limit to current directory for speed
    },
    buffers = {
      prompt_prefix = Icons.file_default,
      sort_mru = true,
      ignore_current_buffer = true,
    },
    live_grep = {
      prompt_prefix = Icons.magnify,
      additional_args = function()
        return { '--hidden', '--smart-case' }
      end,
    },
    grep_string = {
      prompt_prefix = Icons.magnify,
      use_regex = true,
      word_match = '-w',
    },
    help_tags = { prompt_prefix = Icons.question_default },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
    project = {
      display_type = 'full',
      hidden_files = true,
      order_by = 'desc',
      prompt_prefix = Icons.project,
      theme = 'ivy',
      search_by = 'title',
      on_project_selected = function(prompt_bufnr)
        local project_actions = require('telescope._extensions.project.actions')
        project_actions.find_project_files(prompt_bufnr, true)
      end,
    },
  },
})

-- Load extensions with error handling
local function load_extension(name)
  local ok, err = pcall(telescope.load_extension, name)
  if not ok then
    vim.notify('Failed to load telescope extension: ' .. name .. ' - ' .. err, vim.log.levels.WARN)
  end
end

-- Load extensions
load_extension('fzf')
load_extension('vim_bookmarks')
load_extension('project')
load_extension('notify')

-- Helper functions for git integration
local function is_git_repo()
  vim.fn.system('git rev-parse --is-inside-work-tree')
  return vim.v.shell_error == 0
end

local function get_git_root()
  local dot_git_path = vim.fn.finddir('.git', '.;')
  return vim.fn.fnamemodify(dot_git_path, ':h')
end

local function find_files_or_git_files()
  if is_git_repo() then
    builtin.git_files()
  else
    builtin.find_files({
      hidden = true,
      no_ignore = false,
    })
  end
end

local function live_grep_git_root()
  local opts = {}
  if is_git_repo() then
    opts.cwd = get_git_root()
  end
  builtin.live_grep(opts)
end

local function find_visual_selection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})
  text = string.gsub(text, '\n', '')
  builtin.grep_string({ search = text })
end

-- Telescope keymaps
vim.keymap.set('n', '<C-p>', find_files_or_git_files, { desc = 'Find files (git aware)' })
vim.keymap.set('n', '<C-e>', builtin.oldfiles, { desc = 'Recent files' })

vim.keymap.set('n', '<leader>f', live_grep_git_root, { desc = 'Live grep (git root)' })
vim.keymap.set('v', '<leader>f', find_visual_selection, { desc = 'Grep selection' })
vim.keymap.set('n', '<leader>F', builtin.grep_string, { desc = 'Grep string under cursor' })

vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Switch buffers' })
vim.keymap.set('n', 'gh', builtin.help_tags, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find({ prompt_prefix = Icons.magnify })
end, { desc = 'Search in current buffer' })

-- Telescope LSP keymaps
vim.keymap.set('n', ']D', builtin.diagnostics, { desc = 'Workspace diagnostics' })
vim.keymap.set('n', 'grr', builtin.lsp_references, { desc = 'LSP references' })
vim.keymap.set('n', 'gi', builtin.lsp_implementations, { desc = 'LSP implementations' })
vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, { desc = 'LSP type definitions' })
vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { desc = 'LSP document symbols' })

-- User command for registers
vim.keymap.set('i', '<C-R><enter>', builtin.registers, { desc = 'Insert from registers' })
vim.api.nvim_create_user_command('Registers', function()
  builtin.registers()
end, { desc = 'Show registers with Telescope' })

-- Telescope Project integration
local ok, project = pcall(function()
  return telescope.extensions.project
end)
if ok and project then
  vim.keymap.set('n', '<leader>0', project.project, { desc = 'Switch projects' })
end

-- Notification history keymap
vim.keymap.set('n', '<leader><tab>', function()
  require('telescope').extensions.notify.notify()
end, { desc = 'Notification history' })

-- Telescope color theme customization
local function setup_telescope_colors()
  local TelescopeColor = {
    TelescopeMatching = { bold = true, underline = true },
    TelescopeSelection = { fg = Colors.black, bg = Colors.light_green, bold = true },

    TelescopePromptTitle = { bg = Colors.dark_grey, fg = Colors.white },
    TelescopePromptPrefix = { bg = Colors.dark_grey },
    TelescopePromptCounter = { bg = Colors.dark_grey },
    TelescopePromptNormal = { bg = Colors.dark_grey },
    TelescopePromptBorder = { bg = Colors.dark_grey, fg = Colors.grey },

    TelescopeResultsTitle = { fg = Colors.white },
    TelescopeResultsNormal = { fg = Colors.white, bg = Colors.black },
    TelescopeResultsBorder = { bg = Colors.dark_grey, fg = Colors.dark_grey },

    TelescopePreviewTitle = { bg = Colors.dark_grey, fg = Colors.white },
    TelescopePreviewNormal = { bg = Colors.black },
    TelescopePreviewBorder = { bg = Colors.dark_grey, fg = Colors.dark_grey },
  }

  for hl, col in pairs(TelescopeColor) do
    vim.api.nvim_set_hl(0, hl, col)
  end
end

-- Setup colors after colorscheme loads
vim.defer_fn(setup_telescope_colors, 100)
