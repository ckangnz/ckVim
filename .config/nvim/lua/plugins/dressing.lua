-- Set up custom highlight groups for better visibility
local function setup_dressing_highlights()
  -- For input prompts
  vim.api.nvim_set_hl(0, 'DressingInputText', {
    fg = Colors.white,
    bg = Colors.dark_grey,
  })

  vim.api.nvim_set_hl(0, 'DressingInputBorder', {
    fg = Colors.light_grey,
    bg = Colors.black,
  })

  vim.api.nvim_set_hl(0, 'DressingInputTitle', {
    fg = Colors.yellow,
    bg = Colors.dark_grey,
    bold = true,
  })

  -- For select prompts (when using builtin backend)
  vim.api.nvim_set_hl(0, 'DressingSelectText', {
    fg = Colors.white,
    bg = Colors.black,
  })

  vim.api.nvim_set_hl(0, 'DressingSelectIdx', {
    fg = Colors.yellow,
    bg = Colors.black,
    bold = true,
  })

  -- Make sure floating windows have proper background
  vim.api.nvim_set_hl(0, 'NormalFloat', {
    fg = Colors.white,
    bg = Colors.dark_grey,
  })

  vim.api.nvim_set_hl(0, 'FloatBorder', {
    fg = Colors.light_grey,
    bg = Colors.dark_grey,
  })

  vim.api.nvim_set_hl(0, 'FloatTitle', {
    fg = Colors.yellow,
    bg = Colors.dark_grey,
    bold = true,
  })

  -- Fix CodeCompanion prompt highlights specifically
  vim.api.nvim_set_hl(0, 'Question', {
    fg = Colors.yellow,
    bold = true,
  })

  vim.api.nvim_set_hl(0, 'MoreMsg', {
    fg = Colors.green,
    bold = true,
  })

  -- Fix telescope highlights for CodeCompanion prompts
  vim.api.nvim_set_hl(0, 'TelescopePromptTitle', {
    fg = Colors.yellow,
    bg = Colors.dark_grey,
    bold = true,
  })

  vim.api.nvim_set_hl(0, 'TelescopePromptPrefix', {
    fg = Colors.cyan,
    bg = Colors.dark_grey,
  })

  vim.api.nvim_set_hl(0, 'TelescopePromptNormal', {
    fg = Colors.white,
    bg = Colors.dark_grey,
  })

  vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', {
    fg = Colors.white,
    bg = Colors.black,
  })

  vim.api.nvim_set_hl(0, 'TelescopeSelection', {
    fg = Colors.black,
    bg = Colors.light_green,
    bold = true,
  })
end

return {
  'stevearc/dressing.nvim',
  lazy = true,
  init = function()
    -- dressing will hook these functions when the module is loaded
    vim.ui.select = function(...)
      require('lazy').load({ plugins = { 'dressing.nvim' } })
      return vim.ui.select(...)
    end
    vim.ui.input = function(...)
      require('lazy').load({ plugins = { 'dressing.nvim' } })
      return vim.ui.input(...)
    end
  end,
  opts = {
    input = {
      -- Set to false to disable the vim.ui.input implementation
      enabled = true,

      -- Default prompt string
      default_prompt = 'Input:',

      -- Can be 'left', 'right', or 'center'
      title_pos = 'left',

      -- When true, <Esc> will close the modal
      insert_only = true,

      -- When true, input will start in insert mode.
      start_in_insert = true,

      -- These are passed to nvim_open_win
      border = 'rounded',
      -- 'editor' and 'win' will default the position to being centered
      relative = 'cursor',

      -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      prefer_width = 40,
      width = nil,
      -- min_width and max_width can be a list of mixed types.
      -- min_width = {20, 0.2} means "at least 20 columns or 20% of total"
      max_width = { 140, 0.9 },
      min_width = { 20, 0.2 },

      buf_options = {},
      win_options = {
        -- Disable line wrapping
        wrap = false,
        -- Indicator for when text exceeds window
        list = true,
        listchars = 'precedes:…,extends:…',
        -- Increase this for more context
        sidescrolloff = 0,
      },

      -- Set to `false` to disable
      mappings = {
        n = {
          ['<Esc>'] = 'Close',
          ['<CR>'] = 'Confirm',
        },
        i = {
          ['<C-c>'] = 'Close',
          ['<CR>'] = 'Confirm',
          ['<Up>'] = 'HistoryPrev',
          ['<Down>'] = 'HistoryNext',
        },
      },

      override = function(conf)
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        return conf
      end,

      -- see :help dressing_get_config
      get_config = nil,
    },
    select = {
      -- Set to false to disable the vim.ui.select implementation
      enabled = true,

      -- Priority list of preferred vim.ui.select implementations
      backend = { 'telescope', 'fzf_lua', 'fzf', 'builtin', 'nui' },

      -- Trim trailing `:` from prompt
      trim_prompt = true,

      -- Options for telescope selector
      -- These are passed into the telescope picker directly. Can be used like:
      -- dressing.select({'aaa', 'bbb', 'ccc'}, { telescope = telescope_opts })
      telescope = require('telescope.themes').get_dropdown({
        winblend = 10,
        width = 0.5,
        previewer = false,
        prompt_title = false,
        results_title = false,
        sorting_strategy = 'ascending',
        layout_strategy = 'center',
        layout_config = {
          preview_cutoff = 1, -- Preview should never show up
          width = function(_, max_columns, _)
            return math.min(max_columns, 80)
          end,
          height = function(_, _, max_lines)
            return math.min(max_lines, 15)
          end,
        },
        border = true,
        borderchars = {
          prompt = { '─', '│', ' ', '│', '╭', '╮', '│', '│' },
          results = { '─', '│', '─', '│', '├', '┤', '╯', '╰' },
          preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        },
      }),

      -- Options for fzf selector
      fzf = {
        window = {
          width = 0.5,
          height = 0.4,
        },
      },

      -- Options for fzf-lua
      fzf_lua = {
        -- winopts = {
        --   height = 0.5,
        --   width = 0.5,
        -- },
      },

      -- Options for nui Menu
      nui = {
        position = '50%',
        size = nil,
        relative = 'editor',
        border = {
          style = 'rounded',
        },
        buf_options = {
          swapfile = false,
          filetype = 'DressingSelect',
        },
        win_options = {
          winblend = 10,
        },
        max_width = 80,
        max_height = 40,
        min_width = 40,
        min_height = 10,
      },

      -- Options for built-in selector
      builtin = {
        -- Display numbers for options and use number to select
        show_numbers = true,
        -- These are passed to nvim_open_win
        border = 'rounded',
        -- 'editor' and 'win' will default the position to being centered
        relative = 'editor',

        buf_options = {},
        win_options = {
          cursorline = true,
          cursorlineopt = 'both',
        },

        -- When true, <Esc> will close the modal
        insert_only = true,

        -- When true, input will start in insert mode.
        start_in_insert = true,

        -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        width = nil,
        max_width = { 140, 0.8 },
        min_width = { 40, 0.2 },
        height = nil,
        max_height = 0.9,
        min_height = { 10, 0.2 },

        -- Set to `false` to disable
        mappings = {
          ['<Esc>'] = 'Close',
          ['<C-c>'] = 'Close',
          ['<CR>'] = 'Confirm',
        },

        override = function(conf)
          -- This is the config that will be passed to nvim_open_win.
          -- Change values here to customize the layout
          return conf
        end,

        -- see :help dressing_get_config
        get_config = nil,
      },

      -- Used to override format_item. See :help dressing-format
      format_item_override = {},

      -- see :help dressing_get_config
      get_config = function(opts)
        if opts.kind == 'codeaction' then
          return {
            backend = 'telescope',
            telescope = require('telescope.themes').get_cursor({
              prompt_title = 'Code Actions',
            }),
          }
        end
      end,
    },
  },
  config = function(_, opts)
    require('dressing').setup(opts)

    -- Apply highlights after colorscheme loads
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = setup_dressing_highlights,
      desc = 'Setup dressing highlight groups',
    })

    -- Apply highlights immediately
    setup_dressing_highlights()
  end,
}
