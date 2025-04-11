require("kulala").setup({
  vscode_rest_client_environmentvars = false,
  global_keymaps = {
    ["Open scratchpad"] = { "<leader>t", ft = { "http", "rest" }, function() require("kulala").scratchpad() end, },

    ["Open kulala"] = { "<leader>o", ft = { "http", "rest" }, function() require("kulala").open() end, },
    ["Close window"] = false,
    ["Toggle headers/body"] = false,
    ["Show stats"] = false,

    ["Send request"] = false,
    ["Send request <cr>"] = { "<CR>", ft = { "http", "rest" }, function() require("kulala").run() end, mode = { "n", "v" }, },
    ["Send all requests"] = { "<leader>a", ft = { "http", "rest" }, function() require("kulala").run_all() end, mode = { "n", "v" }, },
    ["Inspect current request"] = false,
    ["Replay the last request"] = { "<leader>kl", ft = { "http", "rest" }, function() require("kulala").replay() end, },

    ["Copy as cURL"] = { "<leader>y", ft = { "http", "rest" }, function() require("kulala").copy() end, },
    ["Paste from curl"] = { "<leader>p", ft = { "http", "rest" }, function() require("kulala").from_curl() end, },

    ["Find request"] = { "<leader>f", ft = { "http", "rest" }, function() require("kulala").search() end, },
    ["Jump to next request"] = { "]", ft = { "http", "rest" }, function() require("kulala").jump_next() end, },
    ["Jump to previous request"] = { "[", ft = { "http", "rest" }, function() require("kulala").jump_prev() end, },

    ["Select environment"] = { "<leader>e", ft = { "http", "rest" }, function() require("kulala").set_selected_env() end, },
    ["Download GraphQL schema"] = false,

    ["Clear globals"] = { "<leader>x", ft = { "http", "rest" }, function() require("kulala").scripts_clear_global() end, },
    ["Clear cached files"] = { "<leader>X", ft = { "http", "rest" }, function() require("kulala").clear_cached_files() end, }
  },
  kulala_keymaps = true,
  ui = {
    -- display mode: possible values: "split", "float"
    display_mode = "split",
    -- split direction: possible values: "vertical", "horizontal"
    split_direction = "horizontal",
    -- default view: "body" or "headers" or "headers_body" or "verbose" or fun(response: Response)
    default_view = "headers_body",
    -- enable winbar
    winbar = true,
    -- Specify the panes to be displayed by default
    -- Current available pane contains { "body", "headers", "headers_body", "script_output", "stats", "verbose", "report", "help" },
    default_winbar_panes = { "body", "headers", "headers_body", "verbose", "script_output", "report", "help" },
    -- enable/disable variable info text
    -- this will show the variable name and value as float
    -- possible values: false, "float"
    show_variable_info_text = false,
    -- icons position: "signcolumn"|"on_request"|"above_request"|"below_request" or nil to disable
    show_icons = "on_request",
    -- default icons
    icons = {
      inlay = {
        loading = "⏳",
        done = "✅",
        error = "❌",
      },
      lualine = "🐼",
      textHighlight = "WarningMsg", -- highlight group for request elapsed time
    },
    -- enable/disable request summary in the output window
    show_request_summary = true,
    -- disable notifications of script output
    disable_script_print_output = false,
    report = {
      -- possible values: true | false | "on_error"
      show_script_output = true,
      -- possible values: true | false | "on_error" | "failed_only"
      show_asserts_output = true,
      -- possible values: true | false | "on_error"
      show_summary = true,
      headersHighlight = "Special",
      successHighlight = "String",
      errorHighlight = "Error",
    },
    -- scratchpad default contents
    scratchpad_default_contents = {
      "@MY_TOKEN_NAME=my_token_value",
      "",
      "# @name scratchpad",
      "GET https://httpbin.org/get HTTP/1.1",
      "accept: application/json",
      "",
      "###",
      "",
      "# @name scratchpad",
      "POST https://httpbin.org/post HTTP/1.1",
      "accept: application/json",
      "content-type: application/json",
      "",
      "{",
      '  "foo": "bar"',
      "}",
    },
    disable_news_popup = true,
  },
})
