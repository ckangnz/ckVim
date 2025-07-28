-- Set this in ZSHRC
-- export COPILOT_MODEL="claude-sonnet-4"

vim.api.nvim_create_user_command("ToggleCopilot", "Copilot toggle", { desc = "Toggle Copilot on/off" })
vim.keymap.set('n', '<leader>ct', ':ToggleCopilot<CR>', { desc = 'Toggle Copilot' })

vim.keymap.set('n', '<leader>cp', ':Copilot panel<CR>', { desc = 'Open Copilot panel' })

require('copilot').setup({
  copilot_model = os.getenv("COPILOT_MODEL") or "gpt-4.1",
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-*>"
    },
    layout = {
      position = "bottom",
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
      accept = false, -- refer to keymaps.lua
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
