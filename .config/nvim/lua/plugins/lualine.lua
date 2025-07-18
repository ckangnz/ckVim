local animate = function(icons, duration)
  local ms = vim.loop.hrtime() / 1e6
  local frame = math.floor(ms / duration) % #icons + 1
  return icons[frame]
end

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
        {
          'filename',
          file_status = false,
          path = 1,
        },
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
        { 'codecompanion' },
        {
          'copilot',
          symbols = {
            status = {
              icons = {
                enabled = "  ON",
                sleep = "󰒲 SLP",
                disabled = "  OFF",
                warning = "  WRN",
                unknown = " UNK"
              },
              hl = {
                enabled = Colors.white,
                sleep = Colors.light_grey,
                disabled = Colors.white,
                warning = Colors.dark_red,
                unknown = Colors.light_grey
              }
            },
            spinners = {
              "✶",
              "✸",
              "✹",
              "✺",
              "✹",
              "✷",
            },
            spinner_color = "#61afef"
          },
          show_colors = true,
          show_loading = true
        },
        {
          function()
            local status = vim.fn['codeium#GetStatusString']()
            local robot_icon_on = " "
            local robot_icon_off = " "

            if status == ' * ' then
              local animation = animate({ "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, 150)
              return robot_icon_on .. "  " .. animation
            elseif status == "   " then
              local animation = animate({ ".  ", ".. ", "...", " ..", "  .", "   ", }, 200)
              return robot_icon_on .. animation
            elseif status == ' ON' then
              return robot_icon_on .. status
            elseif status == 'OFF' then
              return robot_icon_off .. status
            else
              return robot_icon_on .. status
            end
          end,
          color = function()
            local status = vim.fn['codeium#GetStatusString']()
            if status == ' * ' then
              return { fg = "#61afef" }
            elseif status == " 0 " then
              return { fg = Colors.light_grey }
            else
              return { fg = Colors.white }
            end
          end,
        },
        { function()
          local status = vim.fn['coc#status']()
          if status == "x" then
            return ""
          else
            return status
          end
        end },
      },
      lualine_z = {
        {
          function()
            local line = vim.fn.line('.')
            local col = vim.fn.col('.')
            return string.format('%03d:%03d', line, col)
          end
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
          section_separators = { left = '', right = '' },
          windows_color = {
            active = { fg = Colors.white, bg = Colors.bluish_black },
            inactive = { fg = Colors.light_grey, bg = Colors.light_black },
          },
          symbols = {
            modified = ' ●', -- Text to show when the buffer is modified
            alternate_file = '#', -- Text to show to identify the alternate file
          },
          disabled_buftypes = { 'quickfix', 'prompt', 'nofile' },
          filetype_names = {
            [''] = '📄 New file',
            TelescopePrompt = '🔍 Telescope',
            fugitive = ' ',
            merginal = ' Branches',
            GV = ' GV',
            qf = '󰁨 quickfix',
            oil = '📂 Files',
            octo = ' Pull Request',
            octo_panel = ' PR Review',
            ['json.kulala_ui'] = "🐼 Kulala",
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
        {
          'tabs',
          separator = { left = '', right = '' },
          max_length = vim.o.columns,
          use_mode_colors = false,
          show_modified_status = false,
          mode = 1,
          tabs_color = {
            active = { fg = Colors.dark_black, bg = Colors.white, gui = 'bold' },
            inactive = { fg = Colors.light_grey, bg = Colors.light_black, gui = 'bold' },
          },
          fmt = function(name, context)
            return '󰓩  ' .. context.tabnr .. ' '
          end
        },
        {
          'g:asyncrun_status',
          fmt = function(status)
            if status == 'running' then
              return animate({ "◴", "◷", "◶", "◵" }, 150)
            elseif status == 'success' then
              return '✓'
            elseif status == 'failure' then
              return '✗'
            else
              return ''
            end
          end,
          color = { fg = Colors.light_grey, bg = Colors.dark_black },
        },
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
