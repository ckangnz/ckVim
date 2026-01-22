require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'gitignore',
    'git_config',
    'git_rebase',
    'gitcommit',
    'gitattributes',

    'vim',
    'vimdoc',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',

    'html',
    'css',
    'scss',
    'javascript',
    'typescript',
    'tsx',
    'json',

    'java',
    'python',
    'c',
    'c_sharp',
    -- 'kotlin',
    -- 'dart',
    -- 'go',
    -- 'rust',
    -- 'ruby',
    -- 'php',

    'yaml',
    -- 'toml',
    'xml',
    'dockerfile',
    'regex',
    'http',

    'hcl',
    'terraform',

    'bash',
    -- 'fish',

    'sql',
    'comment',
  },

  auto_install = false,
  sync_install = false,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function(args)
    local bufnr = args.buf
    local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
    if lang and pcall(vim.treesitter.start, bufnr, lang) then
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          pcall(vim.cmd, 'normal! zx')
        end
      end, 100)
    end
  end,
  desc = 'Setup treesitter folding for supported filetypes',
})

vim.api.nvim_create_user_command('TSReset', function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.treesitter.stop(bufnr)
  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.treesitter.start(bufnr)
      vim.notify('Treesitter reset for buffer ' .. bufnr, vim.log.levels.INFO)
    end
  end, 100)
end, { desc = 'Reset treesitter for current buffer' })
