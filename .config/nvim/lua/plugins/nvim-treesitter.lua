require('nvim-treesitter.config').setup({
  modules = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = function(_, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
      -- Disable for very large files or problematic filetypes
      local lines = vim.api.nvim_buf_line_count(buf)
      if lines > 10000 then
        return true
      end
    end,
  },
  sync_install = false,
  auto_install = true,
  ensure_installed = {
    -- Version control
    'gitignore',
    'git_config',
    'git_rebase',
    'gitcommit',
    'gitattributes',

    -- Editor and documentation
    'vim',
    'vimdoc',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',

    -- Web technologies
    'html',
    'css',
    'scss',
    'javascript',
    'typescript',
    'tsx',
    'json',
    'jsonc',

    -- Programming languages
    'java',
    'python',
    'c',
    'c_sharp',
    'kotlin',
    'dart',
    'go',
    'rust',
    'ruby',
    'php',

    -- Configuration and data
    'yaml',
    'toml',
    'xml',
    'dockerfile',
    'regex',
    'http',

    -- Infrastructure as Code
    'hcl',
    'terraform',

    -- Shell scripting
    'bash',
    'fish',

    -- Other
    'sql',
    'comment',
  },
  ignore_install = {},
  indent = {
    enable = true,
  },
  incremental_selection = { enable = false },
})

if vim.fn.has('unix') == 1 and vim.fn.has('mac') == 1 then
  require('nvim-treesitter.install').compilers = { 'gcc' }
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    local ok, has_parser = pcall(require('nvim-treesitter.parsers').has_parser)
    if ok and has_parser then
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(0) then
          pcall(vim.cmd, 'normal! zx')
        end
      end, 100)
    end
  end,
  desc = 'Setup treesitter folding for supported filetypes',
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'TSHighlightError',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.treesitter.stop(bufnr)
        vim.treesitter.start(bufnr)
      end
    end, 50)
  end,
  desc = 'Auto-reset treesitter on highlighting errors',
})

vim.api.nvim_create_user_command('TSReset', function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.treesitter.stop(bufnr)
  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.treesitter.start(bufnr)
      print('Treesitter reset for buffer ' .. bufnr)
    end
  end, 100)
end, { desc = 'Reset treesitter for current buffer' })
