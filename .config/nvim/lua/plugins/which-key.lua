return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({ global = false })
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
  config = function()
    local wk = require('which-key')
    wk.add({
      { '<leader>e', group = 'Edit files' },
      { '<leader>k', desc = 'Kulala' },
      { '<leader>p', group = 'Lazy shortcuts' },
      { '<leader>w', group = 'Window management' },
    })
  end,
}
