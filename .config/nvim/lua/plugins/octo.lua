if vim.fn.has('nvim') then
  require "octo".setup({
    use_local_fs = false,
    enable_builtin = true,
    default_remote = { "upstream", "origin" },
    default_merge_method = "squash",
    picker = "telescope",
    default_to_projects_v2 = true,
    ui = { use_signcolumn = true },
    comment_icon = "💬 ", -- comment marker
    outdated_icon = "⌛️ ", -- outdated indicator
    resolved_icon = "✅ ", -- resolved indicator
    reaction_viewer_hint_icon = " ", -- marker for user reactions
    user_icon = " ", -- user icon
    timeline_marker = "", -- timeline marker
    timeline_indent = "2", -- timeline indentation
    snippet_context_lines = 4, -- number or lines around commented lines
    right_bubble_delimiter = "", -- bubble delimiter
    left_bubble_delimiter = "", -- bubble delimiter
    timeout = 5000,
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
    colors = {
      white = Colors.white,
      grey = Colors.light_grey,
      black = Colors.light_black,
      red = Colors.red,
      dark_red = Colors.dark_red,
      green = Colors.green,
      dark_green = Colors.dark_green,
      yellow = Colors.yellow,
      dark_yellow = Colors.brow,
      blue = Colors.blue,
      dark_blue = Colors.dark_blue,
      purple = Colors.dark_magenta,
    },
    mappings_disable_default = true,
    mappings = {
      issue = {
        reload = { lhs = "<C-r>", desc = "Reload issue" },
        open_in_browser = { lhs = "<C-b>", desc = "Open in browser" },
        copy_url = { lhs = "<C-y>", desc = "Copy url to system clipboard" },
        next_comment = { lhs = "]c", desc = "Go to next comment" },
        prev_comment = { lhs = "[c", desc = "Go to previous comment" },
      },
      pull_requests = {
        reload = { lhs = "<C-r>", desc = "Reload issue" },
        open_in_browser = { lhs = "<C-b>", desc = "Open in browser" },
        copy_url = { lhs = "<C-y>", desc = "Copy url to system clipboard" },
        next_comment = { lhs = "]c", desc = "Go to next comment" },
        prev_comment = { lhs = "[c", desc = "Go to previous comment" },
      },
      review_thread = {
        next_comment = { lhs = "]c", desc = "Go to next comment" },
        prev_comment = { lhs = "[c", desc = "Go to previous comment" },
        select_next_entry = { lhs = "]q", desc = "Move to previous changed file" },
        select_prev_entry = { lhs = "[q", desc = "Move to next changed file" },
        select_first_entry = { lhs = "[Q", desc = "Move to first changed file" },
        select_last_entry = { lhs = "]Q", desc = "Move to last changed file" },
        close_review_tab = { lhs = "gq", desc = "Close review tab" },
      },
      review_diff = { --Diff split view on review
        add_review_suggestion = { lhs = "<leader>s", desc = "Add a new review suggestion" },
        focus_files = { lhs = "<leader>b", desc = "Move focus to changed file panel" },
        toggle_files = { lhs = "<leader>B", desc = "Hide/show changed files panel" },
        next_thread = { lhs = "]t", desc = "Move to next thread" },
        prev_thread = { lhs = "[t", desc = "Move to previous thread" },
        select_next_entry = { lhs = "]q", desc = "Move to previous changed file" },
        select_prev_entry = { lhs = "[q", desc = "Move to next changed file" },
        select_first_entry = { lhs = "[Q", desc = "Move to first changed file" },
        select_last_entry = { lhs = "]Q", desc = "Move to last changed file" },
        close_review_tab = { lhs = "gq", desc = "Close review tab" },
        toggle_viewed = { lhs = "g<space>", desc = "Toggle viewer viewed state" },
      },
      file_panel = { --Diff split file view on review
        focus_files = { lhs = "<leader>b", desc = "Move focus to changed file panel" },
        toggle_files = { lhs = "<leader>B", desc = "Hide/show changed files panel" },
        refresh_files = { lhs = "<C-r>", desc = "Refresh changed files panel" },
        next_entry = { lhs = "j", desc = "Move to next changed file" },
        prev_entry = { lhs = "k", desc = "Move to previous changed file" },
        select_entry = { lhs = "<cr>", desc = "Show selected changed file diffs" },
        close_review_tab = { lhs = "gq", desc = "Close review tab" },
        toggle_viewed = { lhs = "g<space>", desc = "Toggle viewer viewed state" },
      },
      submit_win = { --Submitting review popup
        approve_review = { lhs = "<C-a>", desc = "Approve review" },
        comment_review = { lhs = "<C-m>", desc = "Comment review" },
        request_changes = { lhs = "<C-r>", desc = "Request changes review" },
        close_review_tab = { lhs = "<C-c>", desc = "Close review tab" },
      },
    },
  })

  vim.keymap.set("n", "<leader>O", "<cmd>Octo<cr>", { noremap = true, silent = true })
  vim.keymap.set("v", "<leader>O", "<cmd>Octo<cr>", { noremap = true, silent = true })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "octo",
    callback = function()
      vim.keymap.set("i", "@", "@<C-x><C-o>", { silent = true, buffer = true })
      vim.keymap.set("i", "#", "#<C-x><C-o>", { silent = true, buffer = true })

      vim.keymap.set("n", "<leader>gd", "<cmd>Octo pr changes<cr>", { noremap = true, silent = true, buffer = true })
      vim.keymap.set("n", "<leader>gc", "<cmd>Octo pr commits<cr>", { noremap = true, silent = true, buffer = true })

      vim.keymap.set("n", "<leader>r", "<cmd>Octo<cr>review", { noremap = true, silent = true, buffer = true })
      vim.keymap.set("n", "<leader>a", "<cmd>Octo<cr>assignee",
        { noremap = true, nowait = true, silent = true, buffer = true })
      vim.keymap.set("n", "<leader>R", "<cmd>Octo<cr>reaction", { noremap = true, silent = true, buffer = true })
      vim.keymap.set("n", "<leader>l", "<cmd>Octo<cr>label", { noremap = true, silent = true, buffer = true })

      vim.keymap.set("n", "<leader>C", "<cmd>Octo<cr>comment", { noremap = true, silent = true, buffer = true })
      vim.keymap.set("v", "<leader>C", "<cmd>Octo<cr>comment", { noremap = true, silent = true, buffer = true })
    end
  })
end
