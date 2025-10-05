vim.cmd('runtime macros/sandwich/keymap/surround.vim')

if vim.g['sandwich#default_recipes'] then
  vim.g['sandwich#recipes'] = vim.fn.deepcopy(vim.g['sandwich#default_recipes'])
end

local custom_recipes = {
  {
    buns = { '{\\s*', '\\s*}' },
    nesting = 1,
    regex = 1,
    match_syntax = 1,
    kind = { 'delete', 'replace', 'textobj' },
    action = { 'delete' },
    input = { '{' },
  },
  {
    buns = { '\\[\\s*', '\\s*\\]' },
    nesting = 1,
    regex = 1,
    match_syntax = 1,
    kind = { 'delete', 'replace', 'textobj' },
    action = { 'delete' },
    input = { '[' },
  },
  {
    buns = { '(\\s*', '\\s*)' },
    nesting = 1,
    regex = 1,
    match_syntax = 1,
    kind = { 'delete', 'replace', 'textobj' },
    action = { 'delete' },
    input = { '(' },
  },
  {
    buns = { '```', '```' },
    nesting = 0,
    match_syntax = 1,
    linewise = 1,
    kind = { 'add', 'replace', 'delete', 'textobj' },
    input = { 'c' },
  },
}

-- Extend the existing recipes with custom ones
vim.g['sandwich#recipes'] = vim.list_extend(vim.g['sandwich#recipes'], custom_recipes)

vim.keymap.set('x', 'is', '<Plug>(textobj-sandwich-auto-i)', { desc = 'Inner sandwich textobj' })
vim.keymap.set('x', 'as', '<Plug>(textobj-sandwich-auto-a)', { desc = 'A sandwich textobj' })
vim.keymap.set('o', 'is', '<Plug>(textobj-sandwich-auto-i)', { desc = 'Inner sandwich textobj' })
vim.keymap.set('o', 'as', '<Plug>(textobj-sandwich-auto-a)', { desc = 'A sandwich textobj' })

-- Comment out highlight settings for now to avoid Colors error
vim.api.nvim_set_hl(0, 'OperatorSandwichChange', {
  ctermfg = 109,
  ctermbg = 237,
  fg = Colors.cyan,
  bg = Colors.dark_grey,
})
vim.api.nvim_set_hl(0, 'OperatorSandwichAdd', {
  bold = true,
  ctermfg = 10,
  fg = Colors.light_green,
})
vim.api.nvim_set_hl(0, 'OperatorSandwichDelete', {
  bold = true,
  ctermfg = 10,
  fg = Colors.light_red,
})
