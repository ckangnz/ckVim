require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = {
        name = "copilot",
        model = 'claude-sonnet-4' -- 'gpt-4'
      },
      opts = { completion_provider = "coc" },
      slash_commands = {
        ["file"] = {
          keymaps = {
            modes = {
              i = "<C-p>",
              n = { "<C-p>" },
            },
          },
        },
        ["buffer"] = {
          keymaps = {
            modes = {
              i = "<C-b>",
              n = { "<C-b>" },
            },
          },
        },
      }
    },
    inline = {
      adapter = {
        name = "copilot",
        model = 'claude-sonnet-4' -- 'gpt-4'
      },
      opts = { completion_provider = "coc" }
    },
    cmd = {
      adapter = {
        name = "copilot",
        model = 'claude-sonnet-4' -- 'gpt-4'
      },
      opts = { completion_provider = "coc" }
    }
  },
  extensions = {
    spinner = {},
  },

})

vim.keymap.set('n', '<M-o>', function() vim.cmd('CodeCompanionChat Toggle') end, { desc = 'Open CodeCompanion Chat' })
vim.keymap.set('n', '<M-p>', ':CodeCompanion ', { desc = 'Open CodeCompanion Prompt' })
vim.keymap.set('v', '<M-p>', ':CodeCompanion ', { desc = 'Open CodeCompanion Prompt with Selection' })
vim.keymap.set('n', '<M-i>', function() vim.cmd('CodeCompanionAction') end, { desc = 'Open CodeCompanion Prompt' })
