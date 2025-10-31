local opt = vim.opt
local g = vim.g

-- Terminal color settings
if vim.fn.has('termguicolors') == 1 then
  opt.termguicolors = true
  vim.env.COLORTERM = 'truecolor'
end

-- Copilot Model
-- export COPILOT_MODEL="claude-sonnet-4"
g.copilot_model = os.getenv('COPILOT_MODEL') or 'gpt-5-mini'

-- ANSI colors for terminal
g.terminal_ansi_colors = {
  Colors.dark_blue,
  Colors.dark_red,
  Colors.dark_green,
  Colors.orange,
  Colors.blue,
  Colors.purple,
  Colors.dark_cyan,
  Colors.white,
  Colors.grey,
  Colors.red,
  Colors.green,
  Colors.yellow,
  Colors.blue,
  Colors.purple,
  Colors.cyan,
  Colors.white,
}

-- Provider settings
g.netrw_keepdir = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

local is_mac = vim.fn.has('unix') == 1 and vim.fn.has('mac') == 1
if is_mac then
  g.python3_host_prog = '/opt/homebrew/bin/python3'
else
  g.python3_host_prog = '/home/linuxbrew/.linuxbrew/bin/python3'
end

-- General settings
opt.re = 0
opt.showmode = false -- Hide --INSERT-- at the bottom
opt.compatible = false -- Latest Vim settings
opt.encoding = 'utf-8'
opt.termguicolors = true
opt.syntax = 'on'

-- Display settings
opt.display:append('lastline') -- Show long lines
opt.number = false -- No line numbers (as per your config)
opt.relativenumber = false
opt.signcolumn = 'yes' -- Show signcolumn
opt.ttyfast = true -- Fast typing/scrolling
opt.laststatus = 2 -- Always show status line

-- Indentation
opt.autoindent = true -- Copy indent from previous line
opt.smartindent = true -- Smart indenting when { is used
opt.tabstop = 2 -- Default tabs
opt.expandtab = false -- Use space as tab
opt.softtabstop = 2 -- Width applied by tab
opt.shiftwidth = 2 -- Width of tab in normal mode

-- Search settings
opt.autoread = true -- Auto refresh when file changed
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- Disable ignorecase when capitals used
opt.hlsearch = true -- Highlight search
opt.incsearch = true -- Show preview of search

-- Behavior
opt.scrolloff = 5 -- Keep cursor away from edges
opt.backspace = { 'indent', 'eol', 'start' } -- Make backspace normal
opt.errorbells = false
opt.visualbell = false
opt.autowriteall = true -- Automatically write file
opt.complete = '.,w,b,u' -- Set autocomplete
opt.shortmess:append('atT') -- Get rid of press enter prompts
opt.updatetime = 500 -- Used for CursorHold
opt.backup = false -- Don't create backup files
opt.writebackup = false -- Don't write backup
opt.swapfile = false -- Don't create swap files
opt.confirm = true -- Prompt when unsaved quits
opt.mouse = 'a' -- Enable mouse

-- Splits
opt.splitbelow = true -- Horizontal split below
opt.splitright = true -- Vertical split right
opt.diffopt:append('vertical') -- Vertical diffs

-- GUI settings
opt.guifont = 'FiraCode Nerd Font:h12'
opt.linespace = 0
opt.wrapmargin = 0
opt.textwidth = 0
opt.guioptions:remove('e') -- Disable tabline
opt.guioptions:remove({ 'l', 'L', 'r', 'R' }) -- Disable scrollbars

-- Cursor shapes
vim.cmd([[
  let &t_SI.="\e[5 q" " Insert mode
  let &t_SR.="\e[4 q" " Replace mode
  let &t_EI.="\e[1 q" " Normal mode
]])

-- Line breaking
if vim.fn.has('linebreak') == 1 then
  opt.breakindent = true
  opt.showbreak = Icons.text_wrap
  opt.cpoptions:append('n')
  opt.breakat = ' ^I!@*-+;:,./?'
end

-- List characters
opt.list = true
opt.listchars = {
  space = ' ',
  tab = Icons.tabs,
  lead = Icons.lead,
  trail = Icons.lead,
  nbsp = Icons.nbsp,
  extends = Icons.triangle_right,
  precedes = Icons.triangle_left,
  multispace = Icons.lead:rep(4),
}

-- Fill characters
opt.fillchars = { stl = ' ' }

-- Folding
opt.foldcolumn = '0'
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Custom fold text function
vim.cmd([[
  function! StyliseFold()
    let indent = indent(v:foldstart)
    let line = '' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '|' . printf(" %10s", lines_count . ' lines' .. ' ◂') . ' |'
    let foldtextstart = strpart(repeat(' ', indent > 0 ? indent - 1 : 0) . '▸' . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return foldtextstart . repeat(' ', winwidth(0)-foldtextlength) .. foldtextend
  endfunction
  set foldtext=StyliseFold()
]])
