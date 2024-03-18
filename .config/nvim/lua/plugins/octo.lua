if vim.fn.has('nvim') then
  require "octo".setup({
    use_local_fs = false,
    enable_builtin = true,
    default_remote = { "upstream", "origin" },
    default_merge_method = "squash",
    picker = "telescope",
    default_to_projects_v2 = true,
    ui = { use_signcolumn = true },
    issues = {
      order_by = {
        field = "CREATED_AT", -- either COMMENTS, CREATED_AT or UPDATED_AT
        direction = "DESC"    -- either DESC or ASC
      }
    },
    pull_requests = {
      order_by = {
        field = "CREATED_AT",                -- either COMMENTS, CREATED_AT or UPDATED_AT
        direction = "DESC"                   -- either DESC or ASC
      },
      always_select_remote_on_create = false -- always give prompt to select base remote repo when creating PRs
    },
    file_panel = {
      size = 10,
      use_icons = true
    },
    comment_icon = "▎", -- comment marker
    outdated_icon = "󰅒 ", -- outdated indicator
    resolved_icon = " ", -- resolved indicator
    reaction_viewer_hint_icon = " ", -- marker for user reactions
    user_icon = " ", -- user icon
    timeline_marker = " ", -- timeline marker
    timeline_indent = "2", -- timeline indentation
    right_bubble_delimiter = "", -- bubble delimiter
    left_bubble_delimiter = "", -- bubble delimiter
    mappings_disable_default = false
  })

  vim.keymap.set("n", "<leader>O", "<cmd>Octo<cr>", { noremap = true, silent = true, buffer = true })
  vim.keymap.set("v", "<leader>O", "<cmd>Octo<cr>", { noremap = true, silent = true, buffer = true })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "octo",
    callback = function()
      vim.keymap.set("i", "@", "@<C-x><C-o>", { silent = true, buffer = true })
      vim.keymap.set("i", "#", "#<C-x><C-o>", { silent = true, buffer = true })
    end
  })
end
