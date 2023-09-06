nnoremap <silent><nowait><C-p>    <cmd>lua require('telescope.builtin').git_files()<CR>
nnoremap <silent><nowait><C-e>    <cmd>lua require('telescope.builtin').oldfiles()<CR>
nnoremap <silent><nowait><leader>f <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <silent><nowait><leader>b <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <silent><nowait><leader>h <cmd>lua require('telescope.builtin').help_tags()<cr>
