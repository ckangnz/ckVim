vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    vim.cmd('normal! zx')
  end,
  desc = 'Expand folds when opening files',
})

require('nvim-treesitter.configs').setup({
  modules = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
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
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
})

if vim.fn.has('unix') == 1 and vim.fn.has('mac') == 1 then
  require('nvim-treesitter.install').compilers = { 'gcc' }
end
