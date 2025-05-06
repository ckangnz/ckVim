vim.g.codeium_enabled = false
vim.g.codeium_disable_bindings = true
vim.g.codeium_no_map_tab = true
vim.g.codeium_render = true
vim.g.codeium_manual = true
vim.g.codeium_tab_fallback = "\t"

vim.keymap.set('i', '<M-w>', function() return vim.fn['codeium#AcceptNextWord()']() end, { expr = true, silent = true })
vim.keymap.set('i', '<M-;>', function() return vim.fn['codeium#AcceptNextLine()']() end, { expr = true, silent = true })
vim.keymap.set('i', '<M-d>', function() return vim.fn['codeium#CycleOrComplete']() end, { expr = true, silent = true })
vim.keymap.set('i', '<M-s>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
vim.keymap.set('i', '<M-f>', function() return vim.fn['codeium#Complete'](-1) end, { expr = true, silent = true })

vim.api.nvim_create_user_command("EnableCodeium", ":Codeium Enable", {})
vim.api.nvim_create_user_command("DisableCodeium", "Codeium Disable", {})

vim.g.codeium_filetypes = {
  ["cs"] = true,
  ["vim"] = true,
  ["python"] = true,
  ["html"] = true,
  ["css"] = true,
  ["sass"] = true,
  ["json"] = true,
  ["flutter"] = true,
  ["kotlin"] = true,
  ["lua"] = true,
  ["docker"] = true,
  ["javascript"] = true,
  ["javascriptreact"] = true,
  ["typescript"] = true,
  ["typescriptreact"] = true
}

vim.keymap.set('i', '<Tab>', function()
  if vim.fn['coc#pum#visible']() == 1 then
    return vim.fn['coc#pum#confirm']()
  elseif vim.fn['coc#expandableOrJumpable']() == 1 then
    return vim.api.nvim_replace_termcodes(
      vim.fn['coc#rpc#request']('doKeymap', { 'snippets-expand-jump', '' }),
      true, true, true
    )
  elseif vim.fn['codeium#Accept']() ~= '' then
    return vim.fn['codeium#Accept']()
  else
    return "\t"
  end
end, { expr = true, silent = true })
