if vim.fn.has('nvim') then
  vim.opt.foldmethod = 'expr'
  vim.opt.foldenable = false
  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.api.nvim_create_autocmd({ "BufEnter" }, { pattern = { "*" }, command = "normal zx" })

  require 'nvim-treesitter.configs'.setup {
    highlight = { enable = true },
    ensure_installed = {
      'gitignore', 'git_config',
      'vim', 'vimdoc', 'lua', 'luadoc', 'markdown', 'markdown_inline',
      'html', 'scss', 'dart',
      'java', 'python', 'c', 'c_sharp', 'kotlin',
      'javascript', 'typescript', 'tsx', 'json',
      'dockerfile',
      'regex',
      'http',
      'hcl',
      'terraform',
      'yaml',
    }
  }
end

if vim.fn.has('unix') and vim.fn.has('mac') then
  require 'nvim-treesitter.install'.compiler = { 'gcc' }
end
