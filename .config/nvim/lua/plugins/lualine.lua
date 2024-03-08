if vim.fn.has('nvim') then
  local custom_theme = {
    normal = {
      a = { fg = Colors.bg1, bg = Colors.aqua, gui = 'bold' },
      b = { fg = Colors.fg1, bg = Colors.bg3 },
      c = { fg = Colors.bg1, bg = 'none' },
      x = { fg = Colors.fg1 }
    },
    insert = {
      a = { fg = Colors.bg1, bg = Colors.yellow, gui = 'bold' },
      b = { fg = Colors.fg1, bg = Colors.bg3 },
    },
    visual = {
      a = { fg = Colors.bg1, bg = Colors.red, gui = 'bold' },
      b = { fg = Colors.fg1, bg = Colors.bg3 },
    },
    replace = {
      a = { fg = Colors.fg0, bg = Colors.purple, gui = 'bold' },
      b = { fg = Colors.fg1, bg = Colors.bg3 },
    },
    command = {
      a = { fg = Colors.bg3, bg = Colors.cyan, gui = 'bold' },
      b = { fg = Colors.fg1, bg = Colors.bg3 },
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
          separator = { left = '' },
        },
        {
          'branch',
          icons_enabled = true,
          separator = { right = '' },
        }
      },
      lualine_b = {
        { 'filetype', colored = true, icon_only = true },
        {
          'filename',
          separator = { right = '' },
        },
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
        { '%{codeium#GetStatusString()}', separator = { left = '' } },
        { 'g:coc_status', separator = { right = '' } },
      },
      lualine_z = {
        { 'g:asyncrun_status', separator = { left = '' } },
        { '%s%l:%v', separator = { right = '' } }
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
        {
          '%s%l:%v',
          separator = { left = '', right = '' }
        }
      }
    },

    tabline = {
      lualine_a = {
        {
          'windows',
          mode = 0,
          max_length = vim.o.columns * 2 / 3,
          show_filename_only = true,
          show_modified_status = true,
          use_mode_colors = true,
          separator = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          symbols = {
            modified = ' ●', -- Text to show when the buffer is modified
            alternate_file = '#', -- Text to show to identify the alternate file
          },
          disabled_buftypes = { 'quickfix', 'prompt' }, -- Hide a window if its buffer's type is disabled
          filetype_names = {
            TelescopePrompt = '🔍',
            GV = ' GV',
            qf = '󰁨 quickfix',
            oil = '📂 Files',
            fugitive = '',
            merginal = ' Branches',
            octo = ' Pull Request',
            octo_panel = ' PR Review'
          },
        }
      },
      lualine_b = {
      },
      lualine_c = {},
      lualine_x = {
        {
          'filetype',
          colored = true,
          icon_only = false,
          separator = { left = '', },
        }
      },
      lualine_y = {
        {
          'tabs',
          max_length = vim.o.columns,
          separator = { left = '', right = '' },
          use_mode_colors = true,
          mode = 1,
          show_modified_status = false,
          ---@diagnostic disable-next-line: unused-local
          fmt = function(name, context)
            return '󰓩  ' .. context.tabnr
          end

        },
      },
      lualine_z = {
        {
          'os.date("%a %d %b |%l:%M%p")',
          separator = { left = '', right = '' }
        },
      }
    },
    winbar = {}
  }
end
