if has('nvim')
lua << EOF
local colors = {
  bg0    = '#1d2021',
  bg1    = '#282828',
  bg3    = '#3c3836',
  red    = '#ea6962',
  green  = '#a9b665',
  yellow = '#d8a657',
  blue   = '#7daea3',
  aqua   = '#89b482',
  grey1   = '#928374',
  purple = '#d3869b',
  fg1    = '#ddc7a1',
  fg0    = '#d4be98',
}

local custom_theme = {
  normal = {
    a = { fg = colors.bg1, bg = colors.aqua, gui='bold' },
    b = { fg = colors.fg1, bg = colors.bg3 },
    c = { fg = colors.bg1, bg = 'none' },
  },
  insert = {
    a = { fg = colors.bg1, bg = colors.yellow, gui='bold'}
  },
  visual = {
    a = { fg = colors.bg1, bg = colors.red , gui='bold'}
  },
  replace = {
    a = { fg = colors.fg0, bg = colors.purple, gui='bold' }
  },

  inactive = {
    a = { fg = colors.grey1, bg = colors.bg1 },
    b = { fg = colors.fg0, bg = colors.bg0 },
    c = { fg = colors.fg0, bg = 'none' },
    x = { fg = colors.fg0, bg = colors.bg0 },
    y = { fg = colors.fg0, bg = colors.bg0 },
    z = { fg = colors.grey1, bg = colors.bg1 },
  },
}

require 'lualine'.setup {
  options = {
    theme = custom_theme,
    section_separators = { left = '', right = '' },
    component_separators = '',
    refresh = { tabline = 100, statusline = 100, }
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
      'g:coc_status',
    },
    lualine_z = {
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
      { 'tabs',
        max_length= vim.o.columns,
        separator = { left = '', right = '' },
        use_mode_colors = false,
        mode = 2,
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      {'filetype', colored = true, icon_only = true},
      {'os.date("%a %d %b |%l:%M%p")', separator = { left = '', right = '' }},
    }
  },
  winbar={}
}
EOF
endif
