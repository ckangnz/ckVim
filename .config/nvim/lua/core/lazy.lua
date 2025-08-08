local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
local plugins = {
  -- Essential
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  {
    'stevearc/oil.nvim',
    event = 'VimEnter',
    cmd = 'Oil',
    keys = { { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' } },
    config = function()
      require('plugins.oil')
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
  },
  {
    'nvim-lualine/lualine.nvim',
    event = { 'UIEnter' },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'Exafunction/windsurf.vim',
      'AndreM222/copilot-lualine',
      'franco-ruggeri/codecompanion-lualine.nvim',
      'franco-ruggeri/mcphub-lualine.nvim',
    },
    config = function()
      require('plugins.lualine')
    end,
  },
  {
    'rcarriga/nvim-notify',
    event = 'VimEnter',
    config = function()
      require('notify').setup({
        stages = 'fade_in_slide_out',
        timeout = 3000,
        max_height = 10,
        max_width = 80,
        top_down = true,
        render = 'default',
        minimum_width = 50,
        fps = 30,
        level = 2,
      })
      vim.notify = require('notify')
    end,
  },
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('plugins.alpha')
    end,
  },

  -- AI
  {
    'Exafunction/windsurf.vim',
    branch = 'main',
    event = 'InsertEnter',
    keys = { '<M-[>', '<M-]>' },
    config = function()
      require('plugins.windsurf')
    end,
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    keys = { '<leader>ct', '<leader>cp', '<M-{>', '<M-}>', '<M-x>' },
    config = function()
      require('plugins.copilot')
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionAction' },
    keys = {
      { '<BS>', desc = 'Toggle CodeCompanion chat', mode = { 'n', 'v' } },
      { '<M-n>', desc = 'Start new CodeCompanion chat' },
      { '<M-p>', desc = 'Open CodeCompanion prompt', mode = { 'n', 'v' } },
      { '<M-o>', desc = 'CodeCompanion actions', mode = { 'n', 'v' } },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-treesitter/nvim-treesitter',
      'hrsh7th/nvim-cmp',
      'nvim-telescope/telescope.nvim',
      'ravitemer/codecompanion-history.nvim',
      { 'stevearc/dressing.nvim', opts = {} },
    },
    config = function()
      require('plugins.codecompanion')
    end,
  },
  {
    'ravitemer/mcphub.nvim',
    cmd = { 'MCPHub' },
    build = 'npm install -g mcp-hub@latest',
    config = function()
      require('mcphub').setup()
    end,
  },

  -- GUI
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.background = 'dark'
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_sign_column_background = 'none'
      vim.g.gruvbox_material_disable_italic_comment = 0
      vim.g.gruvbox_material_palette = 'original'
      vim.g.gruvbox_material_background = 'hard'

      vim.cmd.colorscheme('gruvbox-material')
    end,
  },
  {
    'sphamba/smear-cursor.nvim',
    event = 'VeryLazy',
    opts = {
      normal_bg = nil,
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space = true,
      legacy_computing_symbols_support = false,
      smear_insert_mode = true,
    },
  },
  {
    'norcalli/nvim-colorizer.lua',
    event = 'VeryLazy',
    config = function()
      require('colorizer').setup()
    end,
  },

  -- LSP
  {
    'mason-org/mason.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog' },
    keys = { { '<leader>pm', ':Mason<cr>', desc = 'Open Mason', silent = true } },
    config = function()
      require('plugins.mason')
    end,
  },
  {
    'mason-org/mason-lspconfig.nvim', -- lsp
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'mason-org/mason.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      require('plugins.mason-lsp')
    end,
  },
  {
    'rshkarin/mason-nvim-lint', -- linter
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'mason-org/mason.nvim',
      'mfussenegger/nvim-lint',
    },
    config = function()
      require('plugins.mason-lint')
    end,
  },
  {
    'zapling/mason-conform.nvim', -- formatter
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'mason-org/mason.nvim',
      { 'stevearc/conform.nvim' },
    },
    config = function()
      require('plugins.mason-conform')
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-emoji',
      'hrsh7th/cmp-calc',
      'ray-x/cmp-treesitter',
      'f3fora/cmp-spell',
      {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
        dependencies = {
          'rafamadriz/friendly-snippets',
          'saadparwaiz1/cmp_luasnip',
        },
      },
      {
        'zbirenbaum/copilot-cmp',
        dependencies = 'zbirenbaum/copilot.lua',
        config = function()
          require('copilot_cmp').setup()
        end,
      },
    },
    config = function()
      require('plugins.nvim-cmp')
    end,
  },

  -- Language Specific
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'md', 'codecompanion' },
    config = function()
      require('plugins.render-markdown')
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPre',
    build = ':TSUpdate',
    config = function()
      require('plugins.nvim-treesitter')
    end,
  },
  {
    'pedrohdz/vim-yaml-folds',
    ft = 'yaml',
  },

  -- Git Tools
  {
    'junegunn/gv.vim',
    cmd = { 'GV' },
    dependencies = { 'tpope/vim-fugitive' },
    config = function()
      require('plugins.git')
    end,
  },
  {
    'rhysd/vim-syntax-codeowners',
    ft = 'CODEOWNERS',
  },
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    config = function()
      require('plugins.git')
    end,
  },
  {
    'tpope/vim-rhubarb',
    dependencies = { 'tpope/vim-fugitive' },
  },
  {
    'tyru/open-browser-github.vim',
    dependencies = { 'tyru/open-browser.vim' },
    keys = {
      { ',gog', '<cmd>OpenGithubProject<cr>', desc = 'Open GitHub project' },
      { ',gof', '<cmd>OpenGithubFile<cr>', desc = 'Open current file on GitHub' },
      { ',goi', '<cmd>OpenGithubIssue<cr>', desc = 'Open GitHub issues' },
      {
        ',gor',
        function()
          vim.cmd('OpenGithubPullReq #' .. vim.fn['FugitiveHead']())
        end,
        desc = 'Open current branch PR',
      },
      { ',gop', '<cmd>OpenGithubPullReq<cr>', desc = 'Open GitHub pull requests' },
    },
  },

  -- Pairing
  {
    'machakann/vim-sandwich',
    keys = {
      -- Text objects
      { 'is', mode = { 'x', 'o' } },
      { 'as', mode = { 'x', 'o' } },
      -- Default sandwich operators
      { 'sa', mode = { 'n', 'x' } },
      { 'sd', mode = 'n' },
      { 'sr', mode = 'n' },
      -- Surround.vim compatibility mappings
      { 'S', mode = 'x' },
      { 'ds', mode = 'n' },
      { 'cs', mode = 'n' },
      { 'ys', mode = 'n' },
      { 'yss', mode = 'n' },
      { 'yS', mode = 'n' },
      { 'ySS', mode = 'n' },
    },
    config = function()
      require('plugins.vim-sandwich')
    end,
  },
  {
    'tpope/vim-repeat',
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('plugins.autopairs')
    end,
  },

  -- Database
  {
    'kristijanhusak/vim-dadbod-completion',
    ft = { 'sql', 'mysql', 'plsql' },
    dependencies = 'tpope/vim-dadbod',
  },

  -- Search Tool
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    event = 'VeryLazy',
    cmd = 'Telescope',
    keys = { { '<leader>T', '<cmd>Telescope<cr>', desc = 'Open Telescope', silent = true } },
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
      'nvim-telescope/telescope-project.nvim',
      'tom-anders/telescope-vim-bookmarks.nvim',
    },
    config = function()
      require('plugins.telescope')
    end,
  },

  -- Functionality
  {
    'AndrewRadev/switch.vim',
    cmd = { 'Switch', 'SwitchReverse' },
    keys = {
      {
        '|>',
        ':Switch<CR>',
        desc = 'Switch to next value',
        silent = true,
      },
      {
        '|<',
        ':SwitchReverse<CR>',
        desc = 'Switch to previous value',
        silent = true,
      },
    },
    config = function()
      vim.g.switch_mapping = ''
      vim.g.switch_custom_definitions = {
        { '!NOTE', '!TIP', '!IMPORTANT', '!CAUTION', '!WARNING' },
        {
          ['\\<\\(\\l\\)\\(\\l\\+\\(\\u\\l\\+\\)\\+\\)\\>'] = '\\=toupper(submatch(1)) . submatch(2)',
          ['\\<\\(\\u\\l\\+\\)\\(\\u\\l\\+\\)\\+\\>'] = '\\=tolower(substitute(submatch(0), \'\\(\\l\\)\\(\\u\\)\', \'\\1_\\2\', \'g\'))',
          ['\\<\\(\\l\\+\\)\\(_\\l\\+\\)\\+\\>'] = '\\U\\0',
          ['\\<\\(\\u\\+\\)\\(_\\u\\+\\)\\+\\>'] = '\\=tolower(substitute(submatch(0), \'_\', \'-\', \'g\'))',
          ['\\<\\(\\l\\+\\)\\(-\\l\\+\\)\\+\\>'] = '\\=substitute(submatch(0), \'-\\(\\l\\)\', \'\\u\\1\', \'g\')',
        },
      }
    end,
  },
  {
    'airblade/vim-rooter',
    event = 'VeryLazy',
    config = function()
      vim.g.rooter_silent_chdir = 1
      vim.g.rooter_patterns = { '.git', 'package.json' }
      vim.g.rooter_resolve_links = 1
      vim.g.rooter_change_directory_for_non_project_files = ''
    end,
  },
  {
    'dominikduda/vim_current_word',
    event = 'VeryLazy',
    config = function()
      vim.g['vim_current_word#highlight_current_word'] = 1
      vim.g['vim_current_word#highlight_twins'] = 1
      vim.api.nvim_set_hl(0, 'CurrentWord', {
        bold = true,
        underline = true,
      })
      vim.api.nvim_set_hl(0, 'CurrentWordTwins', {
        bold = true,
        underline = true,
      })
    end,
  },
  {
    'easymotion/vim-easymotion',
    keys = {
      {
        'F',
        '<Plug>(easymotion-overwin-f2)',
        desc = 'EasyMotion: Jump to 2 characters',
      },
    },
    config = function()
      vim.g.EasyMotion_do_mapping = 0 -- Disable default mappings
      vim.g.EasyMotion_smartcase = 1
      vim.g.EasyMotion_use_smartsign_us = 1
      vim.api.nvim_set_hl(0, 'EasyMotionTarget', { link = 'EasyMotionIncSearch' })
      vim.api.nvim_set_hl(0, 'EasyMotionShade', { link = 'Comment' })
      vim.api.nvim_set_hl(0, 'EasyMotionIncSearch', { link = 'IncSearch' })
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'BufReadPost',
    config = function()
      require('plugins.todo-comments')
    end,
  },
  {
    'jannis-baum/vivify.vim',
    ft = 'markdown',
  },
  {
    'kkvh/vim-docker-tools',
    cmd = 'DockerToolsToggle',
    keys = {
      { '<leader>dc', ':DockerToolsToggle<cr>', desc = 'Toggle Docker tools', silent = true },
    },
  },
  { 'markonm/traces.vim' },
  {
    'mattesGroeger/vim-bookmarks',
    keys = { 'mm', 'mi', 'mn', 'mp', 'ma', 'mc', 'mx' },
    config = function()
      require('plugins.vim-bookmarks')
    end,
  },
  {
    'mbbill/undotree',
    keys = {
      {
        '<leader>u',
        ':UndotreeToggle<cr>',
        desc = 'Toggle undo tree',
        silent = true,
      },
    },
    cmd = 'UndotreeToggle',
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_WindowLayout = 3
    end,
  },
  {
    'mistweaverco/kulala.nvim',
    ft = { 'http', 'rest' },
    config = function()
      require('plugins.kulala')
    end,
  },
  {
    'skywind3000/asyncrun.vim',
    dependencies = {
      'rcarriga/nvim-notify',
    },
    cmd = { 'AsyncRun', 'AsyncStop' },
    config = function()
      require('plugins.asyncrun')
    end,
  },
  {
    'wesQ3/vim-windowswap',
    keys = {
      {
        '<leader>ww',
        ':call WindowSwap#EasyWindowSwap()<CR>',
        desc = 'Swap windows',
        silent = true,
      },
    },
    config = function()
      vim.g.windowswap_map_keys = 0 -- Prevent default bindings
    end,
  },

  -- Test
  {
    'vim-test/vim-test',
    cmd = { 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' },
    keys = {
      { ',tt', desc = 'Test nearest' },
      { ',tf', desc = 'Test file' },
      { ',ts', desc = 'Test suite' },
      { ',tl', desc = 'Test last' },
    },
    config = function()
      require('plugins.vim-test')
    end,
  },

  -- DB
  {
    'tpope/vim-dadbod',
    keys = {
      {
        '<leader>db',
        ':DBUI<cr>',
        desc = 'Open database UI',
        silent = true,
      },
    },
    cmd = { 'DB', 'DBUI' },
    dependencies = {
      'kristijanhusak/vim-dadbod-ui',
    },
  },

  -- Snippets
  {
    'andrewstuart/vim-kubernetes',
    ft = 'yaml',
  },
}

-- Setup lazy.nvim
require('lazy').setup(plugins, {
  defaults = {
    lazy = true, -- should plugins be lazy-loaded?
  },
  install = {
    missing = true, -- install missing plugins on startup
    colorscheme = { 'gruvbox-material' },
  },
  checker = {
    enabled = true, -- automatically check for plugin updates
    notify = false, -- don't notify on updates
  },
  change_detection = {
    enabled = true, -- automatically check for config file changes
    notify = true, -- don't notify on changes
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

-- Plugin manager keymaps
vim.keymap.set('n', '<leader>pp', '<cmd>Lazy<cr>', { desc = 'Lazy' })
vim.keymap.set('n', '<leader>pi', '<cmd>Lazy install<cr>', { desc = 'Lazy install' })
vim.keymap.set('n', '<leader>pu', '<cmd>Lazy update<cr>', { desc = 'Lazy update' })
vim.keymap.set('n', '<leader>ps', '<cmd>Lazy sync<cr>', { desc = 'Lazy sync' })
vim.keymap.set('n', '<leader>pc', '<cmd>Lazy clean<cr>', { desc = 'Lazy clean' })
vim.keymap.set('n', '<leader>pl', '<cmd>Lazy log<cr>', { desc = 'Lazy log' })
vim.keymap.set('n', '<leader>pr', '<cmd>Lazy restore<cr>', { desc = 'Lazy restore' })
vim.keymap.set('n', '<leader>px', '<cmd>Lazy clear<cr>', { desc = 'Lazy clear' })
