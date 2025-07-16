vim.api.nvim_create_user_command("ToggleCopilot", ":Copilot toggle", {})

require('copilot').setup({
  copilot_model = "",
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right | horizontal | vertical
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = false,
    hide_during_completion = true,
    debounce = 75,
    trigger_on_accept = false,
    keymap = {
      accept = false,
      accept_word = false,
      accept_line = false,
      prev = "<M-{>",
      next = "<M-}>",
      dismiss = "<M-x>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
})
