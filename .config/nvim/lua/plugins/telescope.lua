if vim.fn.has('nvim') then
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  local action_layout = require('telescope.actions.layout')
  local builtin = require('telescope.builtin')

  telescope.setup {
    defaults = {
      winblend = 0,
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<C-/>"] = action_layout.toggle_preview
        },
      },
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
      },
      file_ignore_patterns = { '.git/', 'node_module/', '*.plist' },
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
      coc = {
        theme = 'ivy',
        prefer_locations = true
      }
    }
  };
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

  local function find_files_or_git_files(opts)
    opts.hidden = true
    if is_git_repo() then opts.cwd = get_git_root() end
    builtin.find_files(opts)
  end

  local function live_grep_git_root(opts)
    if is_git_repo() then opts.cwd = get_git_root() end
    builtin.live_grep(opts)
  end

  local function findVisualSelection(opts)
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})
    text = string.gsub(text, "\n", "")
    opts.search = text
    builtin.grep_string(opts)
  end

  --Telescope Key Binding --------------------------------------------
  vim.keymap.set('n', '<C-p>', function() find_files_or_git_files({ prompt_prefix = '📁 ' }) end)
  vim.keymap.set('n', '<C-e>', function() builtin.oldfiles({ prompt_prefix = '📂 ' }) end)
  vim.keymap.set('n', '<leader>f', function() live_grep_git_root({ prompt_prefix = '🔍 ' }) end)
  vim.keymap.set('v', '<leader>f', function() findVisualSelection({ prompt_prefix = '🔍 ' }) end)
  vim.keymap.set('n', '<leader>F', function() builtin.grep_string({ prompt_prefix = '🔍 ' }) end)
  vim.keymap.set('n', '<leader>b', function() builtin.buffers({ prompt_prefix = '📄 ' }) end)
  vim.keymap.set('n', '<leader>h', function() builtin.help_tags({ prompt_prefix = '❔ ' }) end)

  vim.keymap.set('n', 'gc', ':Telescope coc commands<cr>', { silent = true, nowait = true })
  vim.keymap.set('n', 'gr', ':Telescope coc references_used<cr>', { silent = true, nowait = true })
  vim.keymap.set('n', 'gs', ':Telescope coc workspace_symbols<cr>', { noremap = true, silent = true, nowait = true })
  vim.keymap.set('n', '?', ':Telescope coc document_symbols<cr>', { noremap = true, silent = true, nowait = true })

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
