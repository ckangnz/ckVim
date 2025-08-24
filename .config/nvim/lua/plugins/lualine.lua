local function get_spinner(icons, duration)
  local ms = vim.loop.hrtime() / 1e6
  local frame = math.floor(ms / (duration or 150)) % #icons + 1
  return icons[frame]
end

local function exclude_filetypes(filetypes)
  return not vim.tbl_contains(filetypes or {}, vim.bo.filetype)
end

local winbar_excluded = {
  'fugitive',
  'GV',
  'gitcommit',
  'gitrebase',
  'hgcommit',
  'undotree',
  'docker-tools-container',
  'codecompanion',
  'help',
}

local function get_custom_theme()
  return {
    normal = {
      a = { fg = Colors.black, bg = Colors.green, gui = 'bold' },
      b = { fg = Colors.white, bg = Colors.dark_grey },
      c = { fg = Colors.light_grey, bg = nil },
    },
    insert = {
      a = { fg = Colors.black, bg = Colors.orange, gui = 'bold' },
      b = { fg = Colors.white, bg = Colors.dark_grey },
      c = { fg = Colors.light_grey, bg = nil },
    },
    visual = {
      a = { fg = Colors.black, bg = Colors.light_purple, gui = 'bold' },
      b = { fg = Colors.white, bg = Colors.dark_grey },
      c = { fg = Colors.light_grey, bg = nil },
    },
    replace = {
      a = { fg = Colors.black, bg = Colors.red, gui = 'bold' },
      b = { fg = Colors.white, bg = Colors.dark_grey },
      c = { fg = Colors.light_grey, bg = nil },
    },
    command = {
      a = { fg = Colors.black, bg = Colors.light_blue, gui = 'bold' },
      b = { fg = Colors.white, bg = Colors.dark_grey },
      c = { fg = Colors.light_grey, bg = nil },
    },
    terminal = {
      a = { fg = Colors.black, bg = Colors.light_cyan, gui = 'bold' },
    },
    inactive = {
      a = { fg = Colors.light_grey, bg = Colors.dark_grey },
      b = { fg = Colors.light_grey, bg = Colors.dark_grey },
      c = { fg = nil, bg = nil },
      x = { fg = nil, bg = nil },
      y = { fg = nil, bg = nil },
      z = { fg = Colors.light_grey, bg = Colors.dark_grey },
    },
  }
end

-- Main lualine setup
require('lualine').setup({
  options = {
    theme = get_custom_theme(),
    separator = { left = '', right = '' },
    -- section_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    refresh = { tabline = 100, statusline = 100 },
    globalstatus = true,
    disabled_filetypes = { 'alpha' },
  },
  sections = {
    lualine_a = {
      {
        'mode',
        fmt = function()
          return '󰙱K'
        end,
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
        cond = function()
          return exclude_filetypes({ 'codecompanion' })
        end,
      },
    },
    lualine_c = {
      {
        'diff',
        symbols = { added = ' ', modified = ' ', removed = ' ' },
        separator = { left = '', right = '' },
        cond = function()
          return exclude_filetypes({ 'codecompanion' })
        end,
      },
    },
    lualine_x = {
      {
        'diagnostics',
        always_visible = false,
        sources = { 'nvim_lsp' },
        symbols = { error = ' ', warn = ' ', info = ' ', hint = '󱋴 ' },
      },
      {
        'filetype',
        colored = true,
        icon_only = false,
        separator = { left = '', right = '' },
      },
      {
        'lsp_status',
        icon = ' ',
        symbols = {
          spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
          done = '✓',
          separator = '|',
        },
        ignore_lsp = { 'copilot' },
        separator = { left = '', right = '' },
      },
      {
        function()
          local linters = require('lint').get_running()
          if #linters == 0 then
            return '󰦕'
          end
          return '󱉶 ' .. table.concat(linters, ', ')
        end,
        cond = function()
          return exclude_filetypes({ 'codecompanion', 'help' })
        end,
        separator = { left = '', right = '' },
      },
      {
        function()
          local status, conform = pcall(require, 'conform')
          if not status then
            return 'Conform not installed'
          end
          local ignore_formatters = {
            'codespell',
            'trim_whitespace',
          }
          local lsp_format = require('conform.lsp_format')
          local formatters = conform.list_formatters_for_buffer()
          if formatters and #formatters > 0 then
            local formatterNames = {}
            for _, formatter in ipairs(formatters) do
              -- Check if formatter should be ignored
              local should_ignore = false
              for _, ignored in ipairs(ignore_formatters) do
                if formatter == ignored then
                  should_ignore = true
                  break
                end
              end
              if not should_ignore then
                table.insert(formatterNames, formatter)
              end
            end
            if #formatterNames > 0 then
              return '󰷈 ' .. table.concat(formatterNames, ' ')
            end
          end
          local bufnr = vim.api.nvim_get_current_buf()
          local lsp_clients = lsp_format.get_format_clients({ bufnr = bufnr })
          if not vim.tbl_isempty(lsp_clients) then
            return '󰷈 LSP Formatter'
          end
          return ''
        end,
        separator = { left = '', right = '' },
      },
    },
    lualine_y = {},
    lualine_z = {
      {
        function()
          local line = vim.fn.line('.')
          local col = vim.fn.col('.')
          return string.format('%03d:%03d', line, col)
        end,
        cond = function()
          return exclude_filetypes({ 'codecompanion' })
        end,
      },
    },
  },
  winbar = {
    lualine_a = {
      {
        'filename',
        path = 4,
        symbols = {
          modified = ' ',
          readonly = ' ',
          unnamed = '󱀶 [UNNAMED]',
          newfile = ' [NEW-FILE]',
        },
        cond = function()
          return exclude_filetypes(winbar_excluded)
        end,
      },
    },
  },
  inactive_winbar = {
    lualine_a = {
      {
        'filename',
        path = 4,
        symbols = {
          modified = ' ',
          readonly = ' ',
          unnamed = '󱀶 [UNNAMED]',
          newfile = ' [NEW-FILE]',
        },
        cond = function()
          return exclude_filetypes(winbar_excluded)
        end,
      },
    },
  },
  tabline = {
    lualine_a = {
      {
        'tabs',
        separator = { left = '', right = '' },
        component_separators = { left = '' },
        section_separators = { left = '' },
        max_length = vim.o.columns,
        show_modified_status = false,
        mode = 1,
        use_mode_colors = false,
        tabs_color = Colors and {
          active = { fg = Colors.white, bg = Colors.grey, gui = 'bold' },
          inactive = { fg = Colors.grey, bg = Colors.dark_grey, gui = 'bold' },
        } or {},
        fmt = function(_, context)
          return '󰓩  Tab ' .. context.tabnr
        end,
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {
      {
        'copilot',
        cond = function()
          return exclude_filetypes({ 'codecompanion', 'help', 'fugitive' })
        end,
        symbols = {
          status = {
            icons = {
              enabled = '  ON',
              sleep = '󰒲 SLP',
              disabled = '  OFF',
              warning = '  WRN',
              unknown = ' UNK',
            },
            hl = {
              enabled = Colors.white,
              disabled = Colors.light_grey,
              warning = Colors.light_red,
              sleep = Colors.grey,
              unknown = Colors.grey,
            },
          },
          spinners = { '✶', '✸', '✹', '✺', '✹', '✷' },
          spinner_color = Colors.light_cyan,
        },
        show_colors = true,
        show_loading = true,
      },
      {
        function()
          local robot_icon_on = ' '
          local robot_icon_off = ' '
          local loading_dots = { '.  ', '.. ', '...', ' ..', '  .', '   ' }
          local spinner_icons =
            { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }

          if vim.fn.exists('*codeium#GetStatusString') ~= 1 then
            return robot_icon_off .. ' OFF'
          end
          local ok, status = pcall(vim.fn['codeium#GetStatusString'])
          if not ok or not status then
            return robot_icon_off .. ' OFF'
          end

          if status == ' * ' then
            local spinner = get_spinner(spinner_icons, 150)
            return robot_icon_on .. '  ' .. spinner
          elseif status == '   ' then
            local dots = get_spinner(loading_dots, 200)
            return robot_icon_on .. dots
          elseif status == ' ON' then
            return robot_icon_on .. status
          elseif status == 'OFF' then
            return robot_icon_off .. status
          else
            return robot_icon_on .. status
          end
        end,
        color = function()
          if vim.fn.exists('*codeium#GetStatusString') ~= 1 then
            return { fg = Colors.light_grey }
          end
          local ok, status = pcall(vim.fn['codeium#GetStatusString'])
          if not ok or not status then
            return { fg = Colors.light_grey }
          end
          if status == ' * ' then
            return { fg = Colors.light_cyan }
          elseif status == 'OFF' then
            return { fg = Colors.light_grey }
          else
            return { fg = Colors.white }
          end
        end,
        cond = function()
          return exclude_filetypes({ 'codecompanion', 'help', 'fugitive' })
        end,
      },
    },
    lualine_z = {
      {
        'codecompanion',
        fmt = function(value)
          return value:match('%d+ (.+)')
        end,
        color = { fg = Colors.white, bg = Colors.black },
        icon = '󰛰 ',
        spinner_symbols = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
        done_symbol = '✓',
      },
      {
        'mcphub',
        icon = '󰐻 ',
        spinner_symbols = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
        stopped_symbol = '-',
        color = { fg = Colors.white, bg = Colors.black },
      },
    },
  },
})
