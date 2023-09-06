if has('nvim')
lua << EOF
require('tint').setup({
  tint = -45,
  saturation = 0.6
})
EOF
endif

