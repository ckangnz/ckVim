require("mcphub").setup()
require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = {
        name = "copilot",
        -- "claude-3.7-sonnet", "gemini-2.0-flash-001", "claude-opus-4", "claude-3.7-sonnet-thought", "o3-mini", "gpt-4.1", "gpt-4o",
        model = "claude-sonnet-4",
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
      slash_commands = {
        ["file"] = {
          keymaps = {
            modes = { n = { "<C-p>" }, },
          },
        },
        ["buffer"] = {
          keymaps = {
            modes = { n = { "<C-b>" }, },
          },
        },
      }
    },
    inline = {
      adapter = {
        name = "copilot",
        model = 'claude-sonnet-4'
      },
      opts = { completion_provider = "coc" }
    },
    cmd = {
      adapter = {
        name = "copilot",
        model = 'claude-sonnet-4'
      },
      opts = { completion_provider = "coc" }
    }
  },
  extensions = {
    spinner = {},
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
