-- Set this in ZSHRC
-- export COPILOT_MODEL="claude-sonnet-4"

require("codecompanion").setup({
  display = {
    chat = {
      show_context = true,     -- Show context (from slash commands and variables) in the chat buffer?
      show_settings = true,    -- Show LLM settings at the top of the chat buffer?
      show_token_count = true, -- Show the token count for each response?
    }
  },
  strategies = {
    chat = {
      adapter = {
        name = "copilot",
        model = os.getenv("COPILOT_MODEL") or "gpt-4.1",
      },
      roles = {
        llm = function(adapter)
          return "🤖 CodeCompanion (" .. adapter.formatted_name .. ")"
        end,
        user = "👤 You",
      },
      opts = {
        goto_file_action = 'tabnew', -- press gR to go to file in new tab
        completion_provider = "cmp",
      },
      tools = {
        groups = {
          ["github_pr_workflow"] = {
            description = "GitHub operations from issue to PR",
            tools = {
              -- File operations
              "neovim__read_multiple_files", "neovim__write_file", "neovim__edit_file",
              -- GitHub operations
              "github__list_issues", "github__get_issue", "github__get_issue_comments",
              "github__create_issue", "github__create_pull_request", "github__get_file_contents",
              "github__create_or_update_file", "github__search_code"
            },
          }
        }
      },
      slash_commands = {
        ["file"] = {
          keymaps = {
            modes = { n = { "<C-p>" } },
          },
        },
        ["buffer"] = {
          keymaps = {
            modes = { n = { "<C-b>", "<leader>b" } },
          },
        },
      },
    },
    inline = {
      adapter = {
        name = "copilot",
        model = os.getenv("COPILOT_MODEL") or "gpt-4.1",
      },
      opts = { completion_provider = "cmp" }
    },
    cmd = {
      adapter = {
        name = "copilot",
        model = os.getenv("COPILOT_MODEL") or "gpt-4.1",
      },
      opts = { completion_provider = "cmp" }
    }
  },

  extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        make_tools = true,
        show_server_tools_in_chat = true,
        add_mcp_prefix_to_tool_names = false,
        show_result_in_chat = true,
        format_tool = nil,
        make_vars = true,
        make_slash_commands = true,
      }
    },
    history = {
      enabled = true,
      opts = {
        keymap = "gho",           -- Open history
        save_chat_keymap = "ghi", -- Save current chat
        auto_save = false,
        expiration_days = 0,
        picker = "telescope",
        chat_filter = nil,
        picker_keymaps = {
          rename = { n = "r", i = "<C-r>" },
          delete = { n = "d", i = "<C-d>" },
          duplicate = { n = "<C-y>", i = "<C-y>" },
        },
        auto_generate_title = true,
        title_generation_opts = {
          refresh_every_n_prompts = 0,
          max_refreshes = 3,
          format_title = function(original_title)
            return original_title
          end
        },
        continue_last_chat = false,
        delete_on_clearing_chat = true,
        dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        enable_logging = false,
        summary = {
          create_summary_keymap = "ghs",   -- Save Summary
          browse_summaries_keymap = "ghb", --Open Summary
          generation_opts = {
            adapter = nil,
            model = nil,
            context_size = 90000,
            include_references = true,
            include_tool_outputs = true,
            system_prompt = nil,
            format_summary = nil,
          },
        },
      }
    }
  },
})

vim.keymap.set('n', '<M-o>', function() vim.cmd('CodeCompanionChat') end, { desc = 'Start new CodeCompanion chat' })
vim.keymap.set('n', '<BS>', function() vim.cmd('CodeCompanionChat Toggle') end, { desc = 'Toggle CodeCompanion chat' })
vim.keymap.set('v', '<BS>', function()
  vim.cmd('CodeCompanionChat Add')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name:match('CodeCompanion') then
      local wins = vim.fn.win_findbuf(buf)
      if #wins > 0 then
        vim.api.nvim_set_current_win(wins[1])
        break
      end
    end
  end
end, { desc = 'Add visual selection to CodeCompanion chat' })

vim.keymap.set({ 'n', 'v' }, '<M-p>', ':CodeCompanion ', { desc = 'Open CodeCompanion prompt' })
vim.keymap.set({ 'n', 'v' }, '<M-i>', function() vim.cmd('CodeCompanionAction') end, { desc = 'CodeCompanion actions' })

-- CodeCompanion color theme customization
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = '*',
  callback = function()
    local buf_name = vim.api.nvim_buf_get_name(0)
    if buf_name:match('CodeCompanion') then
      vim.api.nvim_set_hl(0, 'CodeCompanionBackground', { bg = Colors.dark_black })
      vim.opt_local.winhighlight = 'Normal:CodeCompanionBackground,NormalNC:CodeCompanionBackground'
    end
  end,
})
