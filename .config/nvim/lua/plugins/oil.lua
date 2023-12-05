vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

require("oil").setup({
  default_file_explorer = true,
  columns = {
    -- See :help oil-columns for a list of all columns
    "icon",
    -- "size",
    -- "permissions",
    -- "mtime",
  },
  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
  delete_to_trash = false,
  skip_confirm_for_simple_edits = false,
  prompt_save_on_select_new_entry = true,
  cleanup_delay_ms = 2000,
  keymaps = {
    -- See :help oil-actions for a list of all available actions
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["gv"] = "actions.select_vsplit",
    ["gd"] = "actions.select_split",
    ["gt"] = "actions.select_tab",
    ["gy"] = "actions.copy_entry_path",
    ["!"] = "actions.open_cmdline",
    ["<C-/>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-r>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["~"] = "actions.open_cwd",
    ["cd"] = "actions.cd",
    ["tcd"] = "actions.tcd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["gh"] = "actions.toggle_hidden",
  },
  use_default_keymaps = false,
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
    -- This function defines what is considered a "hidden" file
    is_hidden_file = function(name)
      return vim.startswith(name, ".")
    end,
    sort = {
      { "type", "asc" },
      { "name", "asc" },
    },
  },
  float = {
    padding = 2,
    max_width = 0,
    max_height = 0,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
    override = function(conf)
      return conf
    end,
  },
  preview = {
    max_width = 0.9,
    min_width = { 40, 0.4 },
    width = nil,
    max_height = 0.9,
    min_height = { 5, 0.1 },
    height = nil,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
  },
  progress = {
    max_width = 0.9,
    min_width = { 40, 0.4 },
    width = nil,
    max_height = { 10, 0.9 },
    min_height = { 5, 0.1 },
    height = nil,
    border = "rounded",
    minimized_border = "none",
    win_options = {
      winblend = 0,
    },
  },
})
