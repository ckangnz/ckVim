local M = {}

M.acp = {
  rovodev = {
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
    commands = {
      default = {
        'acli',
        'rovodev',
        'acp',
      },
    },
    defaults = {},
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
  },
}

return M
