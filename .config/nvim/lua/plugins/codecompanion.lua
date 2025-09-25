-- Set this in ZSHRC
-- export COPILOT_MODEL="claude-sonnet-4"
local codecompanion = require('codecompanion')

codecompanion.setup({
  display = {
    chat = {
      show_context = true, -- Show context (from slash commands and variables) in the chat buffer?
      show_settings = false, -- Show LLM settings at the top of the chat buffer?
      show_token_count = true, -- Show the token count for each response?
      icons = {
        buffer_pin = Icons.pin,
        buffer_watch = Icons.watch,
      },
      window = {
        layout = 'vertical', -- float|vertical|horizontal|buffer
        border = 'solid',
        height = 1.0,
        width = 0.4,
        relative = 'editor',
        full_height = true,
        sticky = false,
      },
    },
  },
  strategies = {
    chat = {
      adapter = {
        name = 'copilot',
        model = vim.g.copilot_model,
      },
      roles = {
        llm = function(adapter)
          return 'CodeCompanion (' .. adapter.formatted_name .. ')'
        end,
        user = 'You (User)',
      },
      opts = {
        goto_file_action = 'tabnew', -- press gR to go to file in new tab
        completion_provider = 'cmp',
      },
      slash_commands = {
        ['file'] = {
          keymaps = {
            modes = { n = { '<C-p>' } },
          },
        },
        ['buffer'] = {
          keymaps = {
            modes = { n = { '<C-b>', '<leader>b' } },
          },
        },
      },
    },
    inline = {
      adapter = {
        name = 'copilot',
        model = vim.g.copilot_model,
      },
      opts = { completion_provider = 'cmp' },
    },
    cmd = {
      adapter = {
        name = 'copilot',
        model = vim.g.copilot_model,
      },
      opts = { completion_provider = 'cmp' },
    },
  },
  memory = {
    opts = {
      chat = {
        enabled = true,
      },
    },
  },

  extensions = {
    mcphub = {
      callback = 'mcphub.extensions.codecompanion',
      opts = {
        make_tools = true,
        show_server_tools_in_chat = true,
        add_mcp_prefix_to_tool_names = false,
        show_result_in_chat = true,
        format_tool = nil,
        make_vars = true,
        make_slash_commands = true,
      },
    },
    history = {
      enabled = true,
      opts = {
        keymap = 'gho', -- Open history
        save_chat_keymap = 'ghi', -- Save current chat
        auto_save = false,
        expiration_days = 0,
        picker = 'telescope',
        chat_filter = nil,
        picker_keymaps = {
          rename = { n = 'r', i = '<C-r>' },
          delete = { n = 'd', i = '<C-d>' },
          duplicate = { n = '<C-y>', i = '<C-y>' },
        },
        auto_generate_title = true,
        title_generation_opts = {
          refresh_every_n_prompts = 0,
          max_refreshes = 3,
          format_title = function(original_title)
            return original_title
          end,
        },
        continue_last_chat = false,
        delete_on_clearing_chat = true,
        dir_to_save = vim.fn.stdpath('data') .. '/codecompanion-history',
        enable_logging = false,
        summary = {
          create_summary_keymap = 'ghs', -- Save Summary
          browse_summaries_keymap = 'ghb', --Open Summary
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
      },
    },
  },
})

local function find_codecompanion_window()
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    local ok, bufnr = pcall(vim.api.nvim_win_get_buf, winid)
    if ok then
      local ft = vim.bo[bufnr].filetype
      if ft == 'codecompanion' then
        return winid
      end
    end
  end
  return nil
end

vim.keymap.set('n', '<M-n>', function()
  vim.cmd('CodeCompanionChat')
end, { desc = 'Start new CodeCompanion chat' })

vim.keymap.set('n', '<BS>', function()
  local codecompanion_win = find_codecompanion_window()
  local current_win = vim.api.nvim_get_current_win()

  if codecompanion_win then
    if codecompanion_win == current_win then
      codecompanion.toggle()
    else
      vim.api.nvim_set_current_win(codecompanion_win)
    end
  else
    codecompanion.toggle()
  end
end, { desc = 'Toggle or focus CodeCompanion chat' })

vim.keymap.set('v', '<BS>', function()
  vim.cmd('CodeCompanionChat Add')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)

  local codecompanion_win = find_codecompanion_window()
  if codecompanion_win then
    vim.api.nvim_set_current_win(codecompanion_win)
  end
end, { desc = 'Add visual selection to CodeCompanion chat' })

vim.keymap.set({ 'n', 'v' }, '<M-p>', ':CodeCompanion ', { desc = 'Open CodeCompanion prompt' })

vim.keymap.set({ 'n', 'v' }, '<M-o>', function()
  vim.cmd('CodeCompanionAction')
end, { desc = 'CodeCompanion actions' })

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = '*',
  callback = function()
    local buf_name = vim.api.nvim_buf_get_name(0)
    if buf_name:match('CodeCompanion') then
      vim.api.nvim_set_hl(0, 'CodeCompanionBackground', { bg = Colors.black })
      vim.opt_local.winhighlight = 'Normal:CodeCompanionBackground,NormalNC:CodeCompanionBackground'
    end
  end,
})
