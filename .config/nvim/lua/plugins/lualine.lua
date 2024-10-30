if vim.fn.has('nvim') then
  local custom_theme = {
    normal = {
      a = { fg = Colors.black, bg = Colors.main_theme, gui = 'bold' },
      b = { fg = Colors.white, bg = Colors.light_black },
      c = { fg = Colors.light_grey, bg = nil },
    },
    insert = {
      a = { fg = Colors.black, bg = Colors.brown, gui = 'bold' },
      b = { fg = Colors.white, bg = Colors.light_black },
      c = { fg = Colors.light_grey, bg = nil },
    },
    visual = {
      a = { fg = Colors.black, bg = Colors.dark_magenta, gui = 'bold' },
      b = { fg = Colors.white, bg = Colors.light_black },
      c = { fg = Colors.light_grey, bg = nil },
    },
    command = {
      a = { fg = Colors.black, bg = Colors.dark_blue, gui = 'bold' },
      b = { fg = Colors.white, bg = Colors.light_black },
      c = { fg = Colors.light_grey, bg = nil },
    },

    inactive = {
      a = { fg = nil, bg = Colors.dark_black },
      b = { fg = Colors.light_grey, bg = Colors.black },
      c = { fg = nil, bg = nil },
      x = { fg = nil, bg = nil },
      y = { fg = nil, bg = Colors.dark_black },
      z = { fg = Colors.light_grey, bg = Colors.black },
    },
  }

  require 'lualine'.setup {
    options = {
      theme = custom_theme,
      separator = { left = '', right = '' },
      -- section_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      component_separators = '',
      refresh = { tabline = 100, statusline = 100, },
      globalstatus = true,
    },
    sections = {
      lualine_a = {
        {
          'mode',
          fmt = function() return '󰙱K' end,
          icons_enabled = true,
          draw_empty = true,
        },
        { 'branch', icons_enabled = true },
      },
      lualine_b = {
        { 'filename', path = 1 },
      },
      lualine_c = {
        {
          'diff',
          symbols = { added = ' ', modified = ' ', removed = ' ' },
          separator = { left = "", right = "" }
        }
      },
      lualine_x = {
        {
          'diagnostics',
          always_visible = false,
          sources = { 'nvim_diagnostic', 'coc' },
          symbols = { error = ' ', warn = ' ', info = ' ', hint = '󱋴 ' },
          separator = { left = "", right = "" }
        },
        {
          'filetype',
          colored = true,
          icon_only = false,
          separator = { left = "", right = "" }
        },
      },
      lualine_y = {
        { '%{codeium#GetStatusString()}', fmt = function(t) return '󰚩 ' .. t end },
        { 'g:coc_status' },
      },
      lualine_z = {
        { 'g:asyncrun_status' },
        { '%s%l:%v' }
      }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = { { 'filename' } },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { { '%s%l:%v' } }
    },

    tabline = {
      lualine_a = {
        {
          'tabs',
          separator = { left = '', right = '' },
          max_length = vim.o.columns,
          use_mode_colors = true,
          mode = 1,
          tabs_color = {
            active = { fg = Colors.white, bg = Colors.bluish_black, gui = 'bold' },
            inactive = { fg = Colors.light_grey, bg = Colors.light_black, gui = 'bold' },
          },
          show_modified_status = false,
          fmt = function(name, context)
            local isCurrentTab = context.tabnr == vim.api.nvim_tabpage_get_number(0)
            local cwd = vim.fn.getcwd();
            local home = os.getenv("HOME")

            if cwd:sub(1, #home) == home then
              cwd = "~" .. cwd:sub(#home + 1)
            end
            -- Truncate the path to a maximum length (32 characters in this example)
            local last_dir = cwd:match("([^/]+)$")


            if isCurrentTab then
              return '  ' .. "/" .. last_dir
            else
              return '  ' .. context.tabnr
            end
          end
        },
        {
          'windows',
          mode = 0,
          max_length = vim.o.columns * 2 / 3,
          show_filename_only = true,
          show_modified_status = true,
          use_mode_colors = true,
          section_separators = { left = '', right = '' },
          symbols = {
            modified = ' ●', -- Text to show when the buffer is modified
            alternate_file = '#', -- Text to show to identify the alternate file
          },
          disabled_buftypes = { 'quickfix', 'prompt', 'nofile' },
          filetype_names = {
            [''] = '📄 New file',
            TelescopePrompt = '🔍Telescope',
            fugitive = '',
            merginal = ' Branches',
            GV = ' GV',
            qf = '󰁨 quickfix',
            oil = '📂 Files',
            octo = ' Pull Request',
            octo_panel = ' PR Review',
            ['vim-plug'] = "🧩 Vim Plug"
          },
        }
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        -- { 'os.date("%a %d %b |%l:%M%p")' },
      }
    },
    winbar = {}
  }

  local function renameTab()
    local tabName = vim.fn.input("New Tab name: ")
    if tabName == "" then
      print(' ')
      return
    end
    vim.cmd.LualineRenameTab { tabName }
  end

  vim.keymap.set('n', '<leader>T', renameTab, { nowait = true, noremap = true, silent = true })
end
