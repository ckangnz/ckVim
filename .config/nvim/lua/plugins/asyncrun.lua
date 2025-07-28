vim.g.asyncrun_status = ''
vim.g.asyncrun_open = 0

vim.api.nvim_create_autocmd('User', {
  pattern = 'AsyncRunStart',
  callback = function()
    local cmd = vim.g.asyncrun_cmd or 'Unknown command'
    if #cmd > 50 then
      cmd = cmd:sub(1, 47) .. '...'
    end
    require('notify')('Running: ' .. cmd, 'info', { title = 'AsyncRun' })
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'AsyncRunStop',
  callback = function()
    local cmd = vim.g.asyncrun_cmd or 'Unknown command'
    local code = vim.g.asyncrun_code
    if #cmd > 50 then
      cmd = cmd:sub(1, 47) .. '...'
    end
    if code == 0 then
      require('notify')('Completed: ' .. cmd, 'info', { title = 'AsyncRun' })
    else
      require('notify')('Failed: ' .. cmd .. ' (exit code: ' .. code .. ')', 'error', { title = 'AsyncRun' })
    end
  end,
})

vim.api.nvim_create_user_command('Make', function(opts)
  local args = opts.args
  vim.cmd('AsyncRun -program=make @ ' .. args)
end, {
  bang = true,
  nargs = '*',
  complete = 'file',
  desc = 'Async make command'
})
