if vim.fn.has('nvim') then
  local custom_theme = {
    normal = {
      a = { fg = Colors.black, bg = Colors.main_theme, gui = 'bold' },
      b = { fg = Colors.light_grey, bg = Colors.light_black },
      c = { fg = Colors.black, bg = 'none' },
      x = { fg = Colors.light_grey }
    },
    insert = {
      a = { fg = Colors.black, bg = Colors.brown, gui = 'bold' },
      b = { fg = Colors.light_grey, bg = Colors.light_black },
    },
    visual = {
      a = { fg = Colors.black, bg = Colors.dark_magenta, gui = 'bold' },
      b = { fg = Colors.light_grey, bg = Colors.light_black },
    },
    command = {
      a = { fg = Colors.black, bg = Colors.dark_blue, gui = 'bold' },
      b = { fg = Colors.light_grey, bg = Colors.light_black },
    },

    inactive = {
      a = { fg = 'none', bg = Colors.dark_black },
      b = { fg = Colors.white, bg = Colors.black },
      c = { fg = 'none', bg = 'none' },
      x = { fg = 'none', bg = 'none' },
      y = { fg = 'none', bg = Colors.dark_black },
      z = { fg = Colors.white, bg = Colors.black },
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
        },
      },
      lualine_b = {
        { 'filetype', colored = true, icon_only = true },
        { 'filename', separator = { right = '' }, },
      },
      lualine_c = {
        { 'diff', symbols = { added = ' ', modified = ' ', removed = ' ' } }
      },
      lualine_x = {
        {
          'diagnostics',
          always_visible = false,
          sources = { 'nvim_diagnostic', 'coc' },
          symbols = { error = ' ', warn = ' ', info = ' ', hint = '󱋴 ' },
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
      lualine_a = {},
      lualine_b = {
        { 'filename', separator = { left = '', right = '' } }
      },
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
          disabled_buftypes = { 'quickfix', 'prompt', 'nofile' },
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
