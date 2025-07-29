local animate = function(icons, duration)
  local ms = vim.loop.hrtime() / 1e6
  local frame = math.floor(ms / duration) % #icons + 1
  return icons[frame]
end

local function get_custom_theme()
  return {
    normal = {
      a = { fg = Colors.black, bg = Colors.main_theme, gui = "bold" },
      b = { fg = Colors.white, bg = Colors.light_black },
      c = { fg = Colors.light_grey, bg = nil },
    },
    insert = {
      a = { fg = Colors.black, bg = Colors.brown, gui = "bold" },
      b = { fg = Colors.white, bg = Colors.light_black },
      c = { fg = Colors.light_grey, bg = nil },
    },
    visual = {
      a = { fg = Colors.black, bg = Colors.dark_magenta, gui = "bold" },
      b = { fg = Colors.white, bg = Colors.light_black },
      c = { fg = Colors.light_grey, bg = nil },
    },
    command = {
      a = { fg = Colors.black, bg = Colors.dark_blue, gui = "bold" },
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
end

-- Main lualine setup
require("lualine").setup({
  options = {
    theme = get_custom_theme(),
    separator = { left = "", right = "" },
    -- section_separators = { left = '', right = '' },
    section_separators = { left = "", right = "" },
    refresh = { tabline = 100, statusline = 100 },
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function()
          return "󰙱K"
        end,
        icons_enabled = true,
        draw_empty = true,
      },
      { "branch", icons_enabled = true },
    },
    lualine_b = {
      {
        "filename",
        file_status = false,
        path = 1,
      },
    },
    lualine_c = {
      {
        "diff",
        symbols = { added = " ", modified = " ", removed = " " },
        separator = { left = "", right = "" },
      },
    },
    lualine_x = {
      {
        "diagnostics",
        always_visible = false,
        sources = { "nvim_lsp" },
        symbols = { error = " ", warn = " ", info = " ", hint = "󱋴 " },
        separator = { left = "", right = "" },
      },
      {
        "filetype",
        colored = true,
        icon_only = false,
        separator = { left = "", right = "" },
      },
      {
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          local clients = vim.lsp.get_clients({ bufnr = bufnr })
          if #clients == 0 then
            return ""
          end
          local ignored_clients = {
            "copilot",
          }
          local function is_ignored(client_name)
            for _, ignored in ipairs(ignored_clients) do
              if client_name == ignored then
                return true
              end
            end
            return false
          end
          local client_names = {}
          for _, client in ipairs(clients) do
            if not is_ignored(client.name) and vim.lsp.buf_is_attached(bufnr, client.id) then
              table.insert(client_names, client.name)
            end
          end
          if #client_names == 0 then
            return ""
          end
          return " " .. table.concat(client_names, ", ")
        end,
        separator = { left = "", right = "" },
      },
      {
        function()
          local linters = require("lint").get_running()
          if #linters == 0 then
            return "󰦕"
          end
          return "󱉶 " .. table.concat(linters, ", ")
        end,
        color = { fg = Colors.brown },
        separator = { left = "", right = "" },
      },
    },
    lualine_y = {
      {
        "copilot",
        symbols = {
          status = {
            icons = {
              enabled = "  ON",
              sleep = "󰒲 SLP",
              disabled = "  OFF",
              warning = "  WRN",
              unknown = " UNK",
            },
            hl = Colors and {
              enabled = Colors.white,
              disabled = Colors.light_grey,
              warning = Colors.dark_red,
              sleep = Colors.light_black,
              unknown = Colors.light_black,
            } or {},
          },
          spinners = {
            "✶",
            "✸",
            "✹",
            "✺",
            "✹",
            "✷",
          },
          spinner_color = Colors and Colors.dark_cyan or "#cyan",
        },
        show_colors = true,
        show_loading = true,
      },
      {
        function()
          local robot_icon_on = " "
          local robot_icon_off = " "

          if vim.fn.exists("*codeium#GetStatusString") ~= 1 then
            return robot_icon_off .. " OFF"
          end
          local ok, status = pcall(vim.fn["codeium#GetStatusString"])
          if not ok or not status then
            return robot_icon_off .. " OFF"
          end

          if status == " * " then
            local animation =
              animate({ "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, 150)
            return robot_icon_on .. "  " .. animation
          elseif status == "   " then
            local animation = animate({ ".  ", ".. ", "...", " ..", "  .", "   " }, 200)
            return robot_icon_on .. animation
          elseif status == " ON" then
            return robot_icon_on .. status
          elseif status == "OFF" then
            return robot_icon_off .. status
          else
            return robot_icon_on .. status
          end
        end,
        color = function()
          if vim.fn.exists("*codeium#GetStatusString") ~= 1 then
            return { fg = Colors.light_grey }
          end

          local ok, status = pcall(vim.fn["codeium#GetStatusString"])
          if not ok or not status then
            return { fg = Colors.light_grey }
          end
          if status == " * " then
            return { fg = Colors.dark_cyan }
          elseif status == "OFF" then
            return { fg = Colors.light_grey }
          else
            return { fg = Colors.white }
          end
        end,
      },
      {
        "codecompanion",
        fmt = function(value)
          return value:match("%d+ (.+)")
        end,
        color = Colors and { fg = Colors.white, bg = Colors.black } or {},
        icon = "󰛰 ",
        spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
        done_symbol = "✓",
      },
      {
        function()
          if not vim.g.loaded_mcphub then
            return "󰐻 -"
          end

          local count = vim.g.mcphub_servers_count or 0
          local status = vim.g.mcphub_status or "stopped"
          local executing = vim.g.mcphub_executing

          if status == "stopped" then
            return "󰐻 -"
          end

          if executing or status == "starting" or status == "restarting" then
            local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
            local frame = math.floor(vim.loop.now() / 100) % #frames + 1
            return "󰐻 " .. frames[frame]
          end
          return "󰐻 " .. count
        end,
        color = function()
          if not vim.g.loaded_mcphub or not Colors then
            return Colors and { fg = Colors.light_black, bg = Colors.black } or {}
          end

          local status = vim.g.mcphub_status or "stopped"
          if status == "ready" or status == "restarted" then
            return { fg = Colors.white, bg = Colors.black }
          elseif status == "starting" or status == "restarting" then
            return { fg = Colors.brown, bg = Colors.black }
          else
            return { fg = Colors.dark_red, bg = Colors.black }
          end
        end,
      },
    },
    lualine_z = {
      {
        function()
          local line = vim.fn.line(".")
          local col = vim.fn.col(".")
          return string.format("%03d:%03d", line, col)
        end,
      },
    },
  },
  tabline = {
    lualine_a = {
      {
        "windows",
        mode = 0,
        max_length = vim.o.columns * 2 / 3,
        show_filename_only = true,
        show_modified_status = true,
        section_separators = { left = "", right = "" },
        windows_color = Colors and {
          active = { fg = Colors.white, bg = Colors.bluish_black },
          inactive = { fg = Colors.light_grey, bg = Colors.light_black },
        } or {},
        symbols = {
          modified = " ●",
          alternate_file = "#",
        },
        disabled_buftypes = { "quickfix", "prompt", "nofile" },
        filetype_names = {
          [""] = "📄 New file",
          TelescopePrompt = "🔍 Telescope",
          codecompanion = "💬 CodeCompanion",
          fugitive = " ",
          merginal = " Branches",
          GV = " GV",
          qf = "󰁨 quickfix",
          oil = "📂 Files",
          octo = " Pull Request",
          octo_panel = " PR Review",
          ["json.kulala_ui"] = "🐼 Kulala",
          ["vim-plug"] = "🧩 Vim Plug",
        },
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      {
        "tabs",
        separator = { left = "", right = "" },
        max_length = vim.o.columns,
        use_mode_colors = false,
        show_modified_status = false,
        mode = 1,
        tabs_color = Colors and {
          active = { fg = Colors.dark_black, bg = Colors.white, gui = "bold" },
          inactive = { fg = Colors.light_grey, bg = Colors.light_black, gui = "bold" },
        } or {},
        fmt = function(_, context)
          return "󰓩  " .. context.tabnr
        end,
      },
    },
  },
  winbar = {},
})

local function rename_tab()
  local tab_name = vim.fn.input("New Tab name: ")
  if tab_name == "" then
    print(" ")
    return
  end
  vim.cmd.LualineRenameTab({ tab_name })
end
vim.keymap.set("n", "<leader>T", rename_tab, { desc = "Rename current tab" })
