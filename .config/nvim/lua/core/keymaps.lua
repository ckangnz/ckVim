local map = vim.keymap.set

map('n', ';', ':', { desc = 'Enter command mode' })
map('v', ';', ':', { desc = 'Enter command mode' })
map('n', ';;', ';', { desc = 'Repeat f/F/t/T search' })
map('v', ';;', ';', { desc = 'Repeat f/F/t/T search' })

map('n', '<leader>w', '<Nop>', { desc = 'Unmap <leader>w' })
map('n', '<leader>q', '<Nop>', { desc = 'Unmap <leader>q' })

map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })

map('n', 'j', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true, desc = 'Down' })
map('n', 'k', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true, desc = 'Up' })
map('v', 'j', 'gj', { desc = 'Down (wrapped)' })
map('v', 'k', 'gk', { desc = 'Up (wrapped)' })

map('n', '<M-j>', ':m .+1<cr>==', { desc = 'Move line down' })
map('n', '<M-k>', ':m .-2<cr>==', { desc = 'Move line up' })
map('i', '<M-j>', '<Esc>:m .+1<cr>==gi', { desc = 'Move line down (insert)' })
map('i', '<M-k>', '<Esc>:m .-2<cr>==gi', { desc = 'Move line up (insert)' })
map('v', '<M-j>', ':m \'>+1<cr>gv=gv', { desc = 'Move selection down' })
map('v', '<M-k>', ':m \'<-2<cr>gv=gv', { desc = 'Move selection up' })

map('n', '<C-o>', '<C-o>zz', { desc = 'Jump back and center' })
map('n', '<C-i>', '<C-i>zz', { desc = 'Jump forward and center' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })
map('n', 'n', 'nzzzv', { desc = 'Next search result and center' })
map('n', 'N', 'Nzzzv', { desc = 'Previous search result and center' })

map('v', '<leader>y', '"+y', { desc = 'Copy to clipboard' })
map('v', '<leader>p', '"0p', { desc = 'Paste last yanked' })

map('n', '<C-j>', '<C-w><C-j>', { desc = 'Go to lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Go to upper window' })
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Go to left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Go to right window' })

-- Tab management
map('n', '<C-t>', '<cmd>tabedit<cr>', { desc = 'New tab' })
map('n', 'g[', 'gT', { desc = 'Previous tab' })
map('n', 'g]', 'gt', { desc = 'Next tab' })

-- Panel Resizing
map('n', '<leader>wf', '<C-w>|', { desc = 'Maximize window width' })
map('n', '<leader>wm', '<C-w>=', { desc = 'Balance windows' })
map('n', '<leader>wh', '<C-w>t<C-w>K', { desc = 'Change to horizontal layout' })
map('n', '<leader>wv', '<C-w>t<C-w>H', { desc = 'Change to vertical layout' })
map('n', '<leader>wt', '<C-w>T', { desc = 'Move window to new tab' })

-- Better indenting
map('v', '<', '<gv', { desc = 'Decrease indent' })
map('v', '>', '>gv', { desc = 'Increase indent' })

-- Terminal keymaps
map('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Terminal left window nav' })
map('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Terminal down window nav' })
map('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Terminal up window nav' })
map('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Terminal right window nav' })

-- Search utilities
map('v', '//', 'y/<C-R>"<CR>N', { desc = 'Search for selected text' })
map('v', '/', '<Esc>/\\%V', { desc = 'Search within selection' })
map('v', '?', '<Esc>?\\%V', { desc = 'Reverse search within selection' })

-- File/Path keymaps (replacing menu system)
map('n', '<leader>ev', '<cmd>vsp $HOME/.config/nvim/init.lua<cr>', { desc = 'Edit init.lua' })
map('n', '<leader>ec', '<cmd>vsp $HOME/.config/nvim/lua/core<cr>', { desc = 'Open core directory' })
map(
  'n',
  '<leader>ek',
  '<cmd>vsp $HOME/.config/nvim/lua/core/keymaps.lua<cr>',
  { desc = 'Edit keymaps.lua' }
)
map(
  'n',
  '<leader>eh',
  '<cmd>vsp $HOME/.config/nvim/lua/core/highlights.lua<cr>',
  { desc = 'Edit vimhelp.md' }
)
map(
  'n',
  '<leader>eo',
  '<cmd>vsp $HOME/.config/nvim/lua/core/options.lua<cr>',
  { desc = 'Edit options.lua' }
)
map(
  'n',
  '<leader>el',
  '<cmd>vsp $HOME/.config/nvim/lua/core/lazy.lua<cr>',
  { desc = 'Edit lazy.lua' }
)
map(
  'n',
  '<leader>ep',
  '<cmd>vsp $HOME/.config/nvim/lua/plugins/<cr>',
  { desc = 'Open plugins directory' }
)
map('n', '<leader>ez', '<cmd>vsp $HOME/.zshrc<cr>', { desc = 'Edit .zshrc' })
map('n', '<leader>ea', '<cmd>vsp $HOME/.extraAlias.zsh<cr>', { desc = 'Edit .extraAlias.zsh' })
map('n', '<leader>et', '<cmd>vsp $HOME/.config/tmux/tmux.conf<cr>', { desc = 'Edit tmux.conf' })

map('n', '<leader>eP', '<cmd>vsp $HOME/.vim/plugins.zsh<cr>', { desc = 'Edit plugins.zsh' })
map('n', '<leader>em', '<cmd>vsp $HOME/.vim/Makefile<cr>', { desc = 'Edit Makefile' })
map('n', '<leader>ei', '<cmd>vsp $HOME/.vim/install_vim.sh<cr>', { desc = 'Edit install_vim.sh' })
map('n', '<leader>en', '<cmd>vsp $HOME/.vim/notes<cr>', { desc = 'Open notes directory' })
map('n', '<leader>er', '<cmd>vsp $HOME/.vim/README.md<cr>', { desc = 'Edit readme.md' })
map('n', '<leader>ee', '<cmd>vsp $HOME/.vim<cr>', { desc = 'Open ~/.vim directory' })

-- LSP
map('n', 'K', vim.lsp.buf.hover, { silent = true, desc = 'Show hover' })
map('n', 'grn', vim.lsp.buf.rename, { silent = true, desc = 'Rename' })
map('n', 'grr', vim.lsp.buf.references, { silent = true, desc = 'References' })
map('n', '[d', vim.diagnostic.goto_prev, { silent = true, desc = 'Previous Diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { silent = true, desc = 'Next Diagnostic' })
map('n', 'ga', vim.lsp.buf.code_action, { silent = true, desc = 'Code Action' })
map('n', 'gi', vim.lsp.buf.implementation, { silent = true, desc = 'Implementation' })
map('n', 'gd', vim.lsp.buf.definition, { silent = true, desc = 'Go to type_definition' })
map('n', 'gt', vim.lsp.buf.type_definition, { silent = true, desc = 'Type Definition' })
map('n', 'gO', vim.lsp.buf.document_symbol, { silent = true, desc = 'Document Symbols' })
map('n', 'gq', vim.lsp.formatexpr, { silent = true, desc = 'Format' })

vim.lsp.inlay_hint.enable(false)

local function create_menu(items, prompt)
  local options = {}
  local commands = {}

  for i, item in ipairs(items) do
    table.insert(options, item[1])
    commands[i] = item[2]
  end

  vim.ui.select(options, {
    prompt = prompt or 'Select:',
    format_item = function(item)
      return item
    end,
  }, function(choice, idx)
    if choice and idx then
      local command = commands[idx]
      if command then
        vim.cmd(command)
      end
    end
  end)
end

local function utility_menu()
  local utilContent = {
    { 'Generate GUID', 'call GenerateGUID()' },
    { 'Delete all white spaces', '%s/^$\\|^\\s\\+//g' },
    { 'Render Markdown toggle', 'RenderMarkdown toggle' },
    { 'Vivify (Markdown Renderer)', 'Vivify' },
    { 'Yaml Schema', 'CocCommand yaml.selectSchema' },
    { 'Clear Registers', 'call ClearReg()' },
  }

  create_menu(utilContent, 'Utility:')
end
vim.keymap.set('n', '<leader>m', utility_menu, {
  desc = 'Utility menu',
  silent = true,
  nowait = true,
})

local function toggle_quickfix()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_exists = true
      break
    end
  end
  if qf_exists then
    vim.cmd('cclose')
  else
    vim.cmd('botright copen 10')
  end
end
map('n', '<leader>4', toggle_quickfix, { desc = 'Toggle quickfix list' })

map('n', '<Space>', function()
  if vim.fn.foldlevel('.') > 0 then
    return 'za'
  else
    return '<Space>'
  end
end, { expr = true, desc = 'Toggle fold or insert space' })

-- To do list
map('n', '<leader>N', function()
  local todo_text = vim.fn.input('Enter todo: ')
  if todo_text ~= '' then
    local fname = vim.fn.expand('~/.vim/notes/todo.md')
    local winnum = vim.fn.bufwinnr(fname)
    if winnum ~= -1 then
      vim.cmd(winnum .. 'wincmd w')
    else
      vim.cmd('60vsp ' .. fname)
    end
    if #todo_text > 0 and todo_text ~= ' ' then
      vim.fn.append(vim.fn.line('$'), '- [ ] ' .. todo_text)
    end
  end
end, { desc = 'Add TODO item' })

-- Accept Copilot/Codeium(Windsurf)
map('i', '<M-a>', function()
  if require('copilot.suggestion').is_visible() then
    return require('copilot.suggestion').accept('')
  else
    return vim.fn['codeium#Accept']()
  end
end, { expr = true, silent = true, desc = 'Accept AI suggestion' })
