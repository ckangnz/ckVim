if vim.fn.has('nvim') then
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  local action_layout = require('telescope.actions.layout')
  local builtin = require('telescope.builtin')

  telescope.setup {
    defaults = {
      layout_config = { prompt_position = "top" },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim",
        "--hidden",
        "--glob",
        "!**/.git/*",
        "!**/node_module/*",
      },
      sorting_strategy = "ascending",
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<C-/>"] = action_layout.toggle_preview
        },
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
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case"
      },
    }
  };
  require('telescope').load_extension('fzf')

  local function is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0
  end

  local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
  end

  function vim.find_files_or_git_files()
    local opts = { prompt_prefix = '🗂️ ' }
    if is_git_repo() then opts.cwd = get_git_root() end
    builtin.find_files(opts)
  end

  function vim.live_grep_git_root()
    local opts = { prompt_prefix = '🔍 ' }
    if is_git_repo() then opts.cwd = get_git_root() end
    print(opts)
    builtin.live_grep(opts)
  end

  function vim.findVisualSelection()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})
    text = string.gsub(text, "\n", "")
    local opts = { search = text, prompt_prefix = '🔍 ' }
    builtin.grep_string(opts)
  end

  --Telescope Key Binding --------------------------------------------
  vim.keymap.set('n', '<C-p>', vim.find_files_or_git_files)
  vim.keymap.set('n', '<C-e>', builtin.oldfiles, {})
  vim.keymap.set('n', '<leader>f', vim.live_grep_git_root)
  vim.keymap.set('v', '<leader>f', vim.findVisualSelection)
  vim.keymap.set('n', '<leader>F', builtin.grep_string, {})
  vim.keymap.set('n', '<leader>b', builtin.buffers, {})
  vim.keymap.set('n', '<leader>h', builtin.help_tags, {})

  --Telescope Color Theme --------------------------------------------
  local colors = {
    bg0    = '#1d2021',
    bg1    = '#282828',
    red    = '#ea6962',
    green  = '#a9b665',
    yellow = '#d8a657',
    blue   = '#7daea3',
    aqua   = '#89b482',
    grey   = '#7c6f64',
    purple = '#d3869b',
    fg1    = '#ddc7a1',
    fg0    = '#d4be98',
  }

  local TelescopeColor = {
    TelescopeMatching = { fg = colors.red },
    TelescopeSelection = { fg = colors.bg1, bg = colors.green, bold = true },

    TelescopePromptTitle = { bg = colors.bg1, fg = colors.fg0 },
    TelescopePromptPrefix = { bg = colors.bg1 },
    TelescopePromptCounter = { bg = colors.bg1 },
    TelescopePromptNormal = { bg = colors.bg1 },
    TelescopePromptBorder = { bg = colors.bg1, fg = colors.bg1 },

    TelescopeResultsTitle = { fg = colors.bg1 },
    TelescopeResultsNormal = { bg = colors.bg0 },
    TelescopeResultsBorder = { bg = colors.bg1, fg = colors.bg1 },

    TelescopePreviewTitle = { bg = colors.bg1, fg = colors.bg1 },
    TelescopePreviewNormal = { bg = colors.bg0 },
    TelescopePreviewBorder = { bg = colors.bg1, fg = colors.bg1 },
  }

  for hl, col in pairs(TelescopeColor) do
    vim.api.nvim_set_hl(0, hl, col)
  end
end
