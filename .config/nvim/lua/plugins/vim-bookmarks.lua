vim.g.bookmark_sign = Icons.heart
vim.g.bookmark_annotation_sign = Icons.hearts
vim.g.bookmark_highlight_lines = 1
vim.g.bookmark_auto_close = 1
vim.g.bookmark_center = 1
vim.g.bookmark_no_default_key_mappings = 1
vim.g.bookmark_disable_ctrlp = 1

vim.keymap.set(
  'n',
  'mm',
  ':BookmarkToggle<cr>',
  { desc = 'Bookmark Toggle', silent = true, nowait = true }
)
vim.keymap.set(
  'n',
  'mi',
  ':BookmarkAnnotate<cr>',
  { desc = 'Bookmark Annotate', silent = true, nowait = true }
)
vim.keymap.set(
  'n',
  'mj',
  ':BookmarkMoveDown<cr>',
  { desc = 'Bookmark MoveDown', silent = true, nowait = true }
)
vim.keymap.set(
  'n',
  'mk',
  ':BookmarkMoveUp<cr>',
  { desc = 'Bookmark MoveUp', silent = true, nowait = true }
)
vim.keymap.set(
  'n',
  'mn',
  ':BookmarkNext<cr>',
  { desc = 'Bookmark Next', silent = true, nowait = true }
)
vim.keymap.set(
  'n',
  'mp',
  ':BookmarkPrev<cr>',
  { desc = 'Bookmark Previous', silent = true, nowait = true }
)
vim.keymap.set(
  'n',
  'mc',
  ':BookmarkClear<cr>',
  { desc = 'Clear bookmark', silent = true, nowait = true }
)
vim.keymap.set(
  'n',
  'mx',
  ':BookmarkClearAll<cr>',
  { desc = 'Clear all bookmarks', silent = true, nowait = true }
)

-- ms: open telescope vim_bookmarks picker (safe check)
vim.keymap.set('n', 'ms', function()
  local ok, telescope = pcall(require, 'telescope')
  if not ok or not telescope.extensions or not telescope.extensions.vim_bookmarks then
    vim.notify('telescope vim_bookmarks extension not available', vim.log.levels.WARN)
    return
  end
  telescope.extensions.vim_bookmarks.all({
    prompt_title = 'Bookmarks',
    prompt_prefix = Icons.bookmark,
  })
end, { desc = 'Bookmark Search (telescope)', silent = true, nowait = true })

vim.api.nvim_set_hl(0, 'BookmarkSign', {
  bg = 'NONE',
  fg = Colors.light_red,
})

vim.api.nvim_set_hl(0, 'BookmarkLine', {
  bg = Colors.medium_grey,
  fg = 'NONE',
})
vim.api.nvim_set_hl(0, 'BookmarkAnnotationLine', {
  bg = Colors.medium_grey,
  fg = 'NONE',
})
