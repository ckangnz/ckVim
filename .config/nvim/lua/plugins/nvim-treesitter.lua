vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    if require('nvim-treesitter.parsers').has_parser() then
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(0) then
          vim.cmd('normal! zx')
        end
      end, 100)
    end
  end,
  desc = 'Setup treesitter folding for supported filetypes',
})

require('nvim-treesitter.configs').setup({
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
