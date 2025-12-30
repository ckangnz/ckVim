local M = require('codecompanion.adapters')

M.acp = {
  rovodev = function()
    local helpers = require('codecompanion.adapters.acp.helpers')
    return {
      name = 'rovodev',
      type = 'acp',
      formatted_name = 'RovoDev',
      roles = {
        llm = 'assistant',
        user = 'user',
      },
      opts = {
        verbose_output = true,
      },
      -- env = {
      --   USER_EMAIL = os.getenv('USER_EMAIL'),
      --   USER_API_TOKEN = os.getenv('USER_API_TOKEN'),
      -- },
      commands = {
        default = {
          'acli',
          'rovodev',
          'acp',
        },
      },
      defaults = {
        timeout = 60000,
      },
      parameters = {
        protocolVersion = 1,
        clientCapabilities = {
          fs = { readTextFile = true, writeTextFile = true },
        },
        clientInfo = {
          name = 'CodeCompanion.nvim',
          version = '1.0.0',
        },
      },
      handlers = {
        setup = function()
          return true
        end,
        form_messages = function(self, messages, capabilities)
          return helpers.form_messages(self, messages, capabilities)
        end,
        on_exit = function() end,
      },
    }
  end,
}

return M
