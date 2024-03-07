if vim.fn.has('nvim') then
  local custom_theme = {
    normal = {
      a = { fg = Colors.bg1, bg = Colors.aqua, gui = 'bold' },
      b = { fg = Colors.fg1, bg = Colors.bg3 },
      c = { fg = Colors.bg1, bg = 'none' },
    },
    insert = {
      a = { fg = Colors.bg1, bg = Colors.yellow, gui = 'bold' }
    },
    visual = {
      a = { fg = Colors.bg1, bg = Colors.red, gui = 'bold' }
    },
    replace = {
      a = { fg = Colors.fg0, bg = Colors.purple, gui = 'bold' }
    },

    inactive = {
      a = { fg = Colors.grey1, bg = Colors.bg1 },
      b = { fg = Colors.fg0, bg = Colors.bg0 },
      c = { fg = Colors.fg0, bg = 'none' },
      x = { fg = Colors.fg0, bg = Colors.bg0 },
      y = { fg = Colors.fg0, bg = Colors.bg0 },
      z = { fg = Colors.grey1, bg = Colors.bg1 },
    },
  }

  require 'lualine'.setup {
    options = {
      theme = custom_theme,
      section_separators = { left = '', right = '' },
      component_separators = '',
      refresh = { tabline = 100, statusline = 100, }
    },
    sections = {
      lualine_a = {
        {
          'mode',
          fmt = function() return '󰙱K' end,
          icons_enabled = true,
          draw_empty = true,
          separator = { left = '' }
        },
        { 'branch', icons_enabled = true }
      },
      lualine_b = {
        { 'filetype', colored = true, icon_only = true },
        'filename',
      },
      lualine_c = {
        { 'diff', symbols = { added = ' ', modified = ' ', removed = ' ' } }
      },
      lualine_x = {
        {
          'diagnostics',
          always_visible = false,
          sources = { 'coc' },
          symbols = { error = ' ', warn = ' ', info = ' ', hint = '󱋴 ' }
        }
      },
      lualine_y = {
        { '%{codeium#GetStatusString()}', separator = { left = '', right = '' } },
        { 'g:coc_status', separator = { left = '', right = '' } },
      },
      lualine_z = {
        { 'g:asyncrun_status', separator = { left = '', right = '' } },
        { '%s%l:%v', separator = { left = '', right = '' } }
      }
    },
    inactive_sections = {
      lualine_a = {
        { 'filename', separator = { left = '', right = '' } }
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        { '%s%l:%v', separator = { left = '', right = '' } }
      }
    },

    tabline = {
      lualine_a = {
        {
          'windows',
          show_modified_status = true,
          mode = 0,
          max_length = vim.o.columns,
          separator = { left = '', right = '' },
        }
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {
        {
          'tabs',
          max_length = vim.o.columns,
          separator = { left = '', right = '' },
          use_mode_colors = false,
          mode = 1,
        },
      },
      lualine_z = {
        { 'filetype', colored = true, icon_only = false },
        { 'os.date("%a %d %b |%l:%M%p")', separator = { left = '', right = '' } },
      }
    },
    winbar = {}
  }
end
