if has('nvim')
lua << EOF
local colors = {
  bg     = '#1d2021',
  red    = '#cc241d',
  green  = '#98971a',
  yellow = '#d79921',
  blue   = '#458588',
  aqua   = '#8ec07c',
  grey   = '#504945',
  purple = '#b16286',
  fg     = '#fbf1c7',
  black  = '#282828',
}

local custom_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.aqua, gui='bold' },
    b = { fg = colors.fg, bg = colors.grey },
    c = { fg = colors.black, bg = colors.bg },
  },
  insert = {
    a = { fg = colors.black, bg = colors.yellow, gui='bold'}
  },
  visual = {
    a = { fg = colors.fg, bg = colors.red , gui='bold'}
  },
  replace = {
    a = { fg = colors.fg, bg = colors.purple, gui='bold' }
  },

  inactive = {
    a = { fg = colors.grey, bg = colors.black },
    b = { fg = colors.fg, bg = colors.bg },
    c = { fg = colors.fg, bg = colors.bg },
    x = { fg = colors.fg, bg = colors.bg },
    y = { fg = colors.fg, bg = colors.bg },
    z = { fg = colors.grey, bg = colors.black },
  },
}

require 'lualine'.setup {
  options = {
    theme = custom_theme,
    section_separators = { left = '', right = '' },
    component_separators = '',
    refresh = { statusline = 300, }
  },
  sections = {
    lualine_a = {
      { 'mode', fmt = function(str) return '󰙱K' end, icons_enabled=true, draw_empty=true, separator = { left = '' }},
      { 'branch', icons_enabled = true }
    },
    lualine_b = {
      { 'filetype', colored = true, icon_only = true },
      'filename',
    },
    lualine_c = {
      { 'diff', symbols = { added = ' ', modified = ' ', removed = ' ' }}
    },
    lualine_x = {
      { 'diagnostics', always_visible = false, sources = { 'coc' }, symbols = { error = ' ', warn = ' ', info = ' ', hint = '󱋴 ' } }
    },
    lualine_y = {
      '%{codeium#GetStatusString()}',
    },
    lualine_z = {
      { '%l/%L:%1v', separator = { left = '', right = '' } }
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
      { '%l/%L:%1v', separator = { left = '', right = '' } }
    }
  },

  tabline = {
    lualine_a = {
      { 'tabs',
        max_length = vim.o.columns/3,
        separator = { left = '', right = '' },
        use_mode_colors = false,
        mode = 2,
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      { 'fileformat', symbols = { mac = '', unix = ''} },
      {'os.date("%a %d %b |%l:%M%p")', separator = { left = '', right = '' }},
    }
  },
  winbar={}
}
EOF
endif
