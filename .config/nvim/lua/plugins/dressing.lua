local function setup_dressing_highlights()
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
  vim.api.nvim_set_hl(0, 'DressingSelectText', {
    fg = Colors.white,
    bg = Colors.black,
  })
  vim.api.nvim_set_hl(0, 'DressingSelectIdx', {
    fg = Colors.yellow,
    bg = Colors.black,
    bold = true,
  })
end

return {
  'stevearc/dressing.nvim',
  lazy = true,
  init = function()
    local lazy = require('lazy')
    vim.ui.select = function(...)
      lazy.load({ plugins = { 'dressing.nvim' } })
      return vim.ui.select(...)
    end
    vim.ui.input = function(...)
      lazy.load({ plugins = { 'dressing.nvim' } })
      return vim.ui.input(...)
    end
  end,
  opts = {
    input = {
      enabled = true,
      default_prompt = 'Input:',
      title_pos = 'left',
      insert_only = true,
      start_in_insert = true,
      border = 'rounded',
      relative = 'cursor',
      prefer_width = 40,
      width = nil,
      max_width = { 140, 0.9 },
      min_width = { 20, 0.2 },
      buf_options = {},
      win_options = {
        wrap = false,
        list = true,
        listchars = 'precedes:…,extends:…',
        sidescrolloff = 0,
      },
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
        return conf
      end,
      get_config = nil,
    },
    select = {
      enabled = true,
      backend = { 'telescope', 'fzf_lua', 'fzf', 'builtin', 'nui' },
      trim_prompt = true,
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
      fzf = {
        window = {
          width = 0.5,
          height = 0.4,
        },
      },
      fzf_lua = {
        -- winopts = {
        --   height = 0.5,
        --   width = 0.5,
        -- },
      },
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
      builtin = {
        show_numbers = true,
        border = 'rounded',
        relative = 'editor',
        buf_options = {},
        win_options = {
          cursorline = true,
          cursorlineopt = 'both',
        },
        insert_only = true,
        start_in_insert = true,
        width = nil,
        max_width = { 140, 0.8 },
        min_width = { 40, 0.2 },
        height = nil,
        max_height = 0.9,
        min_height = { 10, 0.2 },
        mappings = {
          ['<Esc>'] = 'Close',
          ['<C-c>'] = 'Close',
          ['<CR>'] = 'Confirm',
        },
        override = function(conf)
          return conf
        end,
        get_config = nil,
      },
      format_item_override = {},
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
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = setup_dressing_highlights,
      desc = 'Setup dressing highlight groups',
    })
    setup_dressing_highlights()
  end,
}
