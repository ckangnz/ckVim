return {
  http = {
    claude = function()
      return require('codecompanion.adapters').extend('anthropic', {
        name = 'claude',
        formatted_name = 'Claude',
        env = {
          api_key = function()
            -- export ANTHROPIC_API_KEY="your-code"
            return os.getenv('ANTHROPIC_API_KEY')
          end,
        },
      })
    end,
    openai_responses = function()
      return require('codecompanion.adapters').extend('openai_responses', {
        env = {
          api_key = function()
            -- export OPENAI_API_KEY="your-code"
            return os.getenv('OPENAI_API_KEY')
          end,
        },
      })
    end,
  },
  acp = {
    opts = {
      show_presets = false,
    },
    codex = function()
      return require('codecompanion.adapters.acp').extend('codex', {
        defaults = {
          auth_method = 'chatgpt',
        },
      })
    end,
    ['rovodev'] = function()
      local helpers = require('codecompanion.adapters.acp.helpers')
      return {
        name = 'rovodev',
        type = 'acp',
        formatted_name = 'RovoDev',
        roles = { llm = 'assistant', user = 'user' },
        opts = { verbose_output = true },
        commands = { default = { 'acli', 'rovodev', 'acp' } },
        defaults = { mcpServers = {}, timeout = 60000 },
        parameters = {
          protocolVersion = 1,
          clientCapabilities = {
            fs = { readTextFile = true, writeTextFile = true },
          },
          clientInfo = { name = 'CodeCompanion.nvim', version = '1.0.0' },
        },
        handlers = {
          setup = function()
            return true
          end,
          auth = function()
            return true
          end,
          form_messages = function(self, messages, capabilities)
            return helpers.form_messages(self, messages, capabilities)
          end,
          on_exit = function() end,
        },
      }
    end,
  },
}
