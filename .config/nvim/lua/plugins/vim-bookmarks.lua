-- vim-bookmarks configuration
-- Migrated from plugins/vim-bookmarks.vim

-- Bookmark management plugin

-- Configuration
vim.g.bookmark_sign = ' '
vim.g.bookmark_highlight_lines = 1
vim.g.bookmark_auto_close = 1
vim.g.bookmark_center = 1
vim.g.bookmark_no_default_key_mappings = 1
vim.g.bookmark_disable_ctrlp = 1

-- Bookmark menu function
local function bookmark_menu()
  local bookmarkMenu = {
    { 'Add/Delete bookmark (&m)', 'BookmarkToggle' },
    { 'Bookmark Annotate(&i)', 'BookmarkAnnotate' },
    { '-' },
    { 'Bookmark Search (&s)', "lua require('telescope').extensions.vim_bookmarks.all({ prompt_title='Bookmarks', prompt_prefix='📖 ' })" },
    { '-' },
    { 'Bookmark MoveDown (&j)', 'BookmarkMoveDown' },
    { 'Bookmark MoveUp (&k)', 'BookmarkMoveUp' },
    { 'Bookmark Next (&n)', 'BookmarkNext' },
    { 'Bookmark Previous (&p)', 'BookmarkPrev' },
    { '-' },
    { 'Clear bookmarks (&c)', 'BookmarkClear' },
    { 'Clear all bookmarks (&x)', 'BookmarkClearAll' },
  }

  local bookmarkOpt = { title = 'Bookmarks' }

  -- Check if quickui is available
  if vim.fn.exists('*quickui#context#open') == 1 then
    vim.fn['quickui#context#open'](bookmarkMenu, bookmarkOpt)
  else
    -- Fallback to vim.ui.select if quickui is not available
    local items = {}
    local commands = {}
    for _, item in ipairs(bookmarkMenu) do
      if item[1] ~= '-' then
        table.insert(items, item[1])
        table.insert(commands, item[2])
      end
    end

    vim.ui.select(items, {
      prompt = 'Bookmarks:',
    }, function(choice, idx)
      if choice and commands[idx] then
        if commands[idx]:match('^lua ') then
          loadstring(commands[idx]:sub(5))()
        else
          vim.cmd(commands[idx])
        end
      end
    end)
  end
end

-- Keymaps
vim.keymap.set('n', 'm', bookmark_menu, {
  desc = 'Bookmark menu',
  silent = true,
  nowait = true
})

-- Highlight groups
vim.api.nvim_set_hl(0, 'BookmarkSign', {
  ctermbg = 'NONE',
  ctermfg = 'red',
  bg = 'NONE',
  fg = '#ea6962'
})
vim.api.nvim_set_hl(0, 'BookmarkLine', {
  ctermbg = '3',
  ctermfg = 'NONE',
  bg = '#343434',
  fg = 'NONE'
})
