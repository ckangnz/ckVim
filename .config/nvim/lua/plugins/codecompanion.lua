-- Set this in ZSHRC
-- export LLM_MODEL="claude-sonnet-4"
local codecompanion = require('codecompanion')

local ok, custom_adapters = pcall(require, 'plugins.codecompanion_adapters')
if not ok or type(custom_adapters) ~= 'table' then
  custom_adapters = {}
end

codecompanion.setup({
  display = {
    chat = {
      show_context = true, -- Show context (from slash commands and variables) in the chat buffer?
      show_settings = false, -- Show LLM settings at the top of the chat buffer?
      show_token_count = true, -- Show the token count for each response?
      fold_reasoning = false,
      show_reasoning = true,
      icons = {
        buffer_sync_all = Icons.added_multiple,
        buffer_sync_diff = Icons.diff,
        chat_context = Icons.link,
        chat_fold = Icons.fold,
        tool_pending = Icons.circle,
        tool_in_progress = Icons.loading,
        tool_failure = Icons.error_circle,
        tool_success = Icons.check_circle,
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
    diff = {
      provider_opts = {
        inline = {
          layout = 'buffer',
          opts = {
            context_lines = 3,
            full_width_removed = true,
            show_keymap_hints = true,
            show_removed = true,
          },
        },
      },
    },
  },
  adapters = custom_adapters,
  interactions = {
    chat = {
      adapter = {
        name = vim.g.CODE_COMPANION_AGENT,
        model = vim.g.LLM_MODEL,
      },
      roles = {
        llm = function(adapter)
          return 'CodeCompanion (' .. adapter.formatted_name .. ')'
        end,
        user = 'You (User)',
      },
      opts = {
        goto_file_action = 'tabnew',
        completion_provider = 'cmp',
        show_diff = true,
      },
      slash_commands = {
        ['file'] = {
          keymaps = {
            modes = { n = { '<C-p>' } },
          },
        },
        ['buffer'] = {
          keymaps = {
            modes = {
              i = { '<C-b>' },
              n = { '<C-b>', '<leader>b' },
            },
          },
        },
      },
    },
    inline = {
      adapter = {
        name = vim.g.CODE_COMPANION_AGENT,
        model = vim.g.LLM_MODEL,
      },
      opts = { completion_provider = 'cmp' },
      keymaps = {
        accept_change = {
          modes = { n = '.' },
        },
        reject_change = {
          modes = { n = ',' },
        },
        always_accept = {
          modes = { n = '>' },
        },
      },
    },
    cmd = {
      adapter = {
        name = vim.g.CODE_COMPANION_AGENT,
        model = vim.g.LLM_MODEL,
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
  rules = {
    default = {
      description = 'Collection of common files for all projects',
      files = {
        '.codelassian',
        '.clinerules',
        '.cursor',
        '.cursorrules',
        '.goosehints',
        '.rules',
        '.windsurfrules',
        '.github/copilot-instructions.md',
        '.agent.md',
        'AGENT.md',
        'AGENTS.md',
        { path = 'CLAUDE.md', parser = 'claude' },
        { path = 'CLAUDE.local.md', parser = 'claude' },
        { path = '~/.claude/CLAUDE.md', parser = 'claude' },
      },
      is_preset = true,
    },
    opts = {
      chat = {
        enabled = true,
        default_rules = 'default', -- The rule groups to load
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
        save_chat_keymap = ',sc', -- Save chat
        keymap = ',lc', -- Load chat
        auto_save = false,
        expiration_days = 0,
        picker = 'fzf-lua',
        chat_filter = nil,
        picker_keymaps = {
          rename = { n = 'r', i = '<C-r>' },
          delete = { n = 'd', i = '<C-d>' },
          duplicate = { n = '<C-y>', i = '<C-y>' },
        },
        auto_generate_title = true,
        title_generation_opts = {
          adapter = 'copilot', -- Use an HTTP-based adapter (copilot, openai, anthropic, etc.)
          model = nil, -- Uses the default model for the adapter
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
          create_summary_keymap = ',ss', -- Save Summary
          browse_summaries_keymap = ',ls', --Load Summary
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
