if vim.fn.has('nvim') then
  vim.opt.foldmethod = 'expr'
  vim.opt.foldenable = false
  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.api.nvim_create_autocmd({ "BufEnter" }, { pattern = { "*" }, command = "normal zx" })

  require 'nvim-treesitter.configs'.setup {
    highlight = { enable = true },
    ensure_installed = {
      'vim', 'vimdoc', 'lua', 'luadoc',
      'html', 'scss',
      'python',
      'c', 'c_sharp',
      'javascript', 'typescript', 'tsx', 'json',
      'dockerfile',
      'regex',
      'http',
      'dart',
      'yaml',
      'kotlin'
    }
  }
end

if vim.fn.has('unix') and vim.fn.has('mac') then
  require 'nvim-treesitter.install'.compiler = { 'gcc' }
end
