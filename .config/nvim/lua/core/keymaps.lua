vim.keymap.set('i', '<M-a>', function()
  if require('copilot.suggestion').is_visible() then
    return require('copilot.suggestion').accept('')
  else
    return vim.fn['codeium#Accept']()
  end
end
, { expr = true, silent = true })

vim.keymap.set('i', '<Tab>', function()
  if vim.fn['coc#pum#visible']() == 1 then
    return vim.fn['coc#pum#confirm']()
  elseif vim.fn['coc#expandableOrJumpable']() == 1 then
    return vim.api.nvim_replace_termcodes(
      vim.fn['coc#rpc#request']('doKeymap', { 'snippets-expand-jump', '' }),
      true, true, true
    )
    -- elseif vim.fn['codeium#Accept']() ~= '' then
    --   return vim.fn['codeium#Accept']()
  else
    return "\t"
  end
end, { expr = true, silent = true })
