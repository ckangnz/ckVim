-- Set this in ZSHRC
-- export CODECOMPANION_ADAPTER_NAME="copilot"
-- export CODECOMPANION_ADAPTER_MODEL="claude-sonnet-4"

require("mcphub").setup()
require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = {
        name = os.getenv("CODECOMPANION_ADAPTER_NAME") or "githubmodels",
        model = os.getenv("CODECOMPANION_ADAPTER_MODEL") or "github-4.1",
        -- "claude-3.7-sonnet", "gemini-2.0-flash-001", "claude-opus-4", "claude-3.7-sonnet-thought", "o3-mini", "gpt-4.1", "gpt-4o",
      },
      roles = {
        llm = function(adapter)
          return "🤖 CodeCompanion (" .. adapter.formatted_name .. ")"
        end,
        user = "👤 You",
      },
      opts = {
        goto_file_action = 'tabnew', -- press gR
        completion_provider = "coc",
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
            modes = { n = { "<C-p>" }, },
          },
        },
        ["buffer"] = {
          keymaps = {
            modes = { n = { "<C-b>", "<leader>b" }, },
          },
        },
      },
    },
    inline = {
      adapter = {
        name = os.getenv("CODECOMPANION_ADAPTER_NAME") or "githubmodels",
        model = os.getenv("CODECOMPANION_ADAPTER_MODEL") or "github-4.1",
      },
      opts = { completion_provider = "coc" }
    },
    cmd = {
      adapter = {
        name = os.getenv("CODECOMPANION_ADAPTER_NAME") or "githubmodels",
        model = os.getenv("CODECOMPANION_ADAPTER_MODEL") or "github-4.1",
      },
      opts = { completion_provider = "coc" }
    }
  },
  extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        make_tools = true,                    -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
        show_server_tools_in_chat = true,     -- Show individual tools in chat completion (when make_tools=true)
        add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
        show_result_in_chat = true,           -- Show tool results directly in chat buffer
        format_tool = nil,                    -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
        make_vars = true,                     -- Convert MCP resources to #variables for prompts
        make_slash_commands = true,           -- Add MCP prompts as /slash commands
      }
    },
    history = {
      enabled = true,
      opts = {
        keymap = "gho",
        save_chat_keymap = "ghi",
        auto_save = true,
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
          adapter = os.getenv("CODECOMPANION_ADAPTER_NAME") or "githubmodels",
          model = os.getenv("CODECOMPANION_ADAPTER_MODEL") or "github-4.1",
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
          -- Keymap to generate summary for current chat
          create_summary_keymap = "ghs",
          -- Keymap to browse summaries
          browse_summaries_keymap = "ghb",
          generation_opts = {
            adapter = nil,               -- defaults to current chat adapter
            model = nil,                 -- defaults to current chat model
            context_size = 90000,        -- max tokens that the model supports
            include_references = true,   -- include slash command content
            include_tool_outputs = true, -- include tool execution results
            system_prompt = nil,         -- custom system prompt (string or function)
            format_summary = nil,        -- custom function to format generated summary e.g to remove <think/> tags from summary
          },
        },
      }
    }
  },
})

vim.keymap.set('n', '<M-o>', function() vim.cmd('CodeCompanionChat') end, { desc = 'Start a new CodeCompanion Chat' })
vim.keymap.set('n', '<BS>', function() vim.cmd('CodeCompanionChat Toggle') end, { desc = 'Toggle CodeCompanion Chat' })
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
end, { desc = 'Add visual selection to CodeCompanion Chat' })

vim.keymap.set({ 'n', 'v' }, '<M-p>', ':CodeCompanion ', { desc = 'Open CodeCompanion Prompt' })
vim.keymap.set({ 'n', 'v' }, '<M-i>', function() vim.cmd('CodeCompanionAction') end,
  { desc = 'Open CodeCompanion Prompt' })
