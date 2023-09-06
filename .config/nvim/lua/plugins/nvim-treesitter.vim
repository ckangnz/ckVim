if has('nvim')
lua << EOF
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
EOF
endif
