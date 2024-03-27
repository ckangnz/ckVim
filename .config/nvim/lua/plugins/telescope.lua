if vim.fn.has('nvim') then
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  local action_layout = require('telescope.actions.layout')
  local builtin = require('telescope.builtin')

  local select_one_or_multi = function(prompt_bufnr)
    local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
    local multi = picker:get_multi_selection()
    if not vim.tbl_isempty(multi) then
      require("telescope.actions").send_selected_to_qflist(prompt_bufnr)
      require("telescope.actions").open_qflist()
    else
      require('telescope.actions').select_default(prompt_bufnr)
    end
  end

  telescope.setup {
    defaults = {
      winblend = 0,
      layout_config = { prompt_position = "top" },
      path_display = { 'smart' },
      sorting_strategy = "ascending",
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<C-/>"] = action_layout.toggle_preview,
          ["<CR>"] = select_one_or_multi,
        },
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--no-ignore-vcs",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim",
        "--hidden",
      },
      file_ignore_patterns = {
        '.git/+',
        'node_module/*',
        '*.plist',
        'plugged/*',
        'autoload/*',
        'dist/*'
      },
      preview = {
        mime_hook = function(filepath, bufnr, opts)
          local is_image = function()
            local image_extensions = { 'png', 'jpg' }
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
            vim.fn.jobstart({ 'catimg', filepath }, { on_stdout = send_output, stdout_buffered = true, pty = true })
          else
            require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
          end
        end
      },
    },
    pickers = {
      find_files = { prompt_prefix = '📁 ' },
      oldfiles = { prompt_prefix = '📁 ' },
      buffers = { prompt_prefix = '📄 ' },
      live_grep = { prompt_prefix = '🔍 ' },
      grep_string = { prompt_prefix = '🔍 ', use_regex = true },
      help_tags = { prompt_prefix = '❔ ' },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case"
      },
      coc = {
        theme = 'ivy',
        prefer_locations = true
      },
    }
  };
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('coc')
  require('telescope').load_extension('vim_bookmarks')

  local function is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0
  end

  local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
  end

  local function find_files_or_git_files()
    local opts = { hidden = true }
    if is_git_repo() then opts.cwd = get_git_root() end
    builtin.find_files(opts)
  end

  local function live_grep_git_root()
    local opts = {}
    if is_git_repo() then opts.cwd = get_git_root() end
    builtin.live_grep(opts)
  end

  local function findVisualSelection()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})
    text = string.gsub(text, "\n", "")
    builtin.grep_string({ search = text })
  end

  --Telescope Key Binding --------------------------------------------
  vim.keymap.set('n', '<C-p>', function() find_files_or_git_files() end, { noremap = true, silent = true, nowait = true })
  vim.keymap.set('n', '<C-e>', ':lua require("telescope.builtin").oldfiles{}<cr>',
    { noremap = true, silent = true, nowait = true })

  vim.keymap.set('n', '<leader>f', function() live_grep_git_root() end, { noremap = true, silent = true, nowait = true })
  vim.keymap.set('v', '<leader>f', function() findVisualSelection() end, { noremap = true, silent = true, nowait = true })
  vim.keymap.set('n', '<leader>F', ':lua require("telescope.builtin").grep_string{}<cr>',
    { noremap = true, silent = true, nowait = true }
  )

  vim.keymap.set('n', '<leader>b', ':lua require("telescope.builtin").buffers{}<cr>',
    { noremap = true, silent = true, nowait = true })

  vim.keymap.set('n', '<leader>h', ':lua require("telescope.builtin").help_tags{}<cr>',
    { noremap = true, silent = true, nowait = true })

  vim.keymap.set('n', 'gc', ':lua require("telescope").load_extension("coc").commands{prompt_prefix="⭐️ "}<cr>',
    { silent = true, nowait = true })
  vim.keymap.set('n', 'gr',
    ':lua require("telescope").load_extension("coc").references_used{prompt_prefix="🔗 ", path_display={"shorten","smart"}}<cr>',
    { silent = true, nowait = true })
  vim.keymap.set('n', 'gs',
    ':lua require("telescope").load_extension("coc").workspace_symbols{prompt_prefix="#️⃣  "}<cr>',
    { noremap = true, silent = true, nowait = true })
  vim.keymap.set('n', '?', ':lua require("telescope.builtin").current_buffer_fuzzy_find{prompt_prefix="🔍 "}<cr>',
    { noremap = true, silent = true, nowait = true })

  --Telescope Color Theme --------------------------------------------
  local TelescopeColor = {
    TelescopeMatching = { bold = true, underline = true },
    TelescopeSelection = { fg = Colors.black, bg = Colors.main_theme, bold = true },

    TelescopePromptTitle = { bg = Colors.black, fg = Colors.light_grey },
    TelescopePromptPrefix = { bg = Colors.black },
    TelescopePromptCounter = { bg = Colors.black },
    TelescopePromptNormal = { bg = Colors.black },
    TelescopePromptBorder = { bg = Colors.black, fg = Colors.black },

    TelescopeResultsTitle = { fg = Colors.black },
    TelescopeResultsNormal = { bg = Colors.dark_black },
    TelescopeResultsBorder = { bg = Colors.black, fg = Colors.black },

    TelescopePreviewTitle = { bg = Colors.black, fg = Colors.black },
    TelescopePreviewNormal = { bg = Colors.dark_black },
    TelescopePreviewBorder = { bg = Colors.black, fg = Colors.black },
  }

  for hl, col in pairs(TelescopeColor) do
    vim.api.nvim_set_hl(0, hl, col)
  end
end
