if vim.fn.has('nvim') then
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  local builtin = require('telescope.builtin')
  local state = require('telescope.actions.state')

  local select_one_or_multi = function(prompt_bufnr)
    local multi = state.get_current_picker(prompt_bufnr):get_multi_selection()
    if not vim.tbl_isempty(multi) then
      actions.send_selected_to_qflist(prompt_bufnr)
      actions.open_qflist()
    else
      actions.select_default(prompt_bufnr)
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
          ["<esc>"] = 'close',
          ["<CR>"] = select_one_or_multi,
          ["<C-j>"] = 'preview_scrolling_down',
          ["<C-k>"] = 'preview_scrolling_up',
          ["<C-h>"] = 'preview_scrolling_left',
          ["<C-l>"] = 'preview_scrolling_right',
          ["<C-/>"] = 'which_key',
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
        '.git/*',
        'node_module/*',
        '*.plist',
        'plugged/*',
        'autoload/*',
        'esm/*',
        'cjs/*',
        'dist/*',
        'yarn.lock',
        '%.tsx%.html$',
      },
      preview = {
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
      project = {
        display_type = "full",
        hidden_files = true,
        order_by = "desc",
        prompt_prefix = "🗂️ ",
        theme = 'ivy',
        search_by = "title",
        on_project_selected = function(prompt_bufnr)
          local project_actions = require("telescope._extensions.project.actions")
          -- local selected_title = project_actions.get_selected_title(prompt_bufnr)
          -- vim.cmd.LualineRenameTab { selected_title }
          project_actions.find_project_files(prompt_bufnr, true)
        end
      }
    }
  };
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('coc')
  require('telescope').load_extension('vim_bookmarks')
  require('telescope').load_extension('project')

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
  vim.keymap.set('n', '<C-e>', builtin.oldfiles,
    { noremap = true, silent = true, nowait = true })

  vim.keymap.set('n', '<leader>f', function() live_grep_git_root() end, { noremap = true, silent = true, nowait = true })
  vim.keymap.set('v', '<leader>f', function() findVisualSelection() end, { noremap = true, silent = true, nowait = true })
  vim.keymap.set('n', '<leader>F', builtin.grep_string,
    { noremap = true, silent = true, nowait = true }
  )

  vim.keymap.set('i', '<C-R><enter>', builtin.registers, { noremap = true, silent = true, nowait = true })
  vim.api.nvim_create_user_command("Registers", function() require('telescope.builtin').registers() end, {})

  vim.keymap.set('n', '<leader>b', builtin.buffers, { noremap = true, silent = true, nowait = true })

  vim.keymap.set('n', 'gh', builtin.help_tags, { noremap = true, silent = true, nowait = true })

  vim.keymap.set('n', '?', function() builtin.current_buffer_fuzzy_find({ prompt_prefix = "🔍 " }) end,
    { noremap = true, silent = true, nowait = true })

  -- Telescope COC
  vim.keymap.set('n', 'gc', function() telescope.extensions.coc.commands({ prompt_prefix = "⭐️ " }) end,
    { silent = true, nowait = true })
  vim.keymap.set('n', 'gr', function()
      telescope.extensions.coc.references_used({ prompt_prefix = "🔗 ", path_display = { "shorten", "smart" } })
    end,
    { silent = true, nowait = true })
  vim.keymap.set('n', 'gs', function() telescope.extensions.coc.workspace_symbols({ prompt_prefix = "#️⃣  " }) end,
    { noremap = true, silent = true, nowait = true })


  -- Telescope Project
  vim.keymap.set('n', '<leader>0', telescope.extensions.project.project, { noremap = true, silent = true })


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
