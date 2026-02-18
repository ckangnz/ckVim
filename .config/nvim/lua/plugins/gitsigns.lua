local gitsigns = require('gitsigns')

gitsigns.setup({
  signs = {
    add = { text = '┃' },
    change = { text = '┃' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  signs_staged = {
    add = { text = '┃' },
    change = { text = '┃' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  signs_staged_enable = true,
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,
  max_file_length = 40000,
  preview_config = {
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1,
  },
  on_attach = function(bufnr)
    local function map(mode, l, r, description)
      local opts = {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts, description)
    end

    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    map('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
    map('v', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
    map('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
    map('v', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
    map('n', '<leader>gw', '<cmd>Gitsigns stage_buffer<CR>')
    map('n', '<leader>gr', '<cmd>Gitsigns reset_buffer<CR>')
    map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
    map('n', '<leader>hi', '<cmd>Gitsigns preview_hunk_inline<CR>')
    map('n', '<leader>gdf', '<cmd>Gitsigns diffthis<CR>')
    map('n', '<leader>gdF', ':Gitsigns diffthis ')
    map('n', '<leader>hb', '<cmd>Gitsigns blame_line<CR>')
    map('n', '<leader>hq', '<cmd>Gitsigns setqflist<CR>')
    map('n', '<leader>htb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
    map('n', '<leader>htw', '<cmd>Gitsigns toggle_word_diff<CR>')
    map('n', '<leader>htd', '<cmd>Gitsigns toggle_deleted<CR>')
    map({ 'o', 'x' }, 'ih', '<cmd>Gitsigns select_hunk<CR>')
  end,
})
