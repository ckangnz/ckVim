local cmp = require('cmp')
local luasnip = require('luasnip')

require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath('config') .. '/snippets' } })

local kind_icons = {
  Text = "󰈙",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "󰤔",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "󰜰",
  Module = "󰏗",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "󰕘",
  Keyword = "󰌋",
  Snippet = "󰩫",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "󰕘",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "󰉁",
  Operator = "󰆕",
  TypeParameter = "󰊄",
  Copilot = "󰚩",
  Codeium = "󰘦",
}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noselect',
  },
  window = {
    completion = cmp.config.window.bordered({
      border = 'rounded',
      winhighlight = 'Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSelection,Search:None',
      scrollbar = false,
      max_width = 50,
      max_height = 10,
    }),
    documentation = cmp.config.window.bordered({
      border = 'rounded',
      winhighlight = 'Normal:CmpDocNormal,FloatBorder:CmpDocBorder',
      max_width = 60,
      max_height = 15,
    }),
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or '', vim_item.kind)

      -- Source
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        luasnip = '[Snip]',
        buffer = '[Buf]',
        path = '[Path]',
        nvim_lua = '[Lua]',
        copilot = '[AI]',
        codeium = '[AI]',
        emoji = '[Emoji]',
        calc = '[Calc]',
        treesitter = '[TS]',
        spell = '[Spell]',
      })[entry.source.name] or '[Other]'

      -- Truncate long items
      if string.len(vim_item.abbr) > 40 then
        vim_item.abbr = string.sub(vim_item.abbr, 1, 37) .. '...'
      end

      return vim_item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-j>'] = cmp.mapping.scroll_docs(4),
    ['<C-k>'] = cmp.mapping.scroll_docs(-4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm({ select = true }),
      c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  }),

  -- Sources configuration (ordered by priority)
  sources = cmp.config.sources({
    { name = 'codecompanion', priority = 1000 },
    { name = 'copilot',       priority = 1000 },
    { name = 'nvim_lsp',      priority = 900 },
    { name = 'luasnip',       priority = 800 },
    { name = 'nvim_lua',      priority = 700 },
  }, {
    { name = 'buffer',     priority = 500, max_item_count = 5 },
    { name = 'path',       priority = 400 },
    { name = 'emoji',      priority = 300 },
    { name = 'calc',       priority = 200 },
    { name = 'treesitter', priority = 100 },
  }),
  experimental = {
    ghost_text = {
      hl_group = 'CmpGhostText',
    },
  },
  performance = {
    debounce = 60,
    throttle = 30,
    fetching_timeout = 500,
    confirm_resolve_timeout = 80,
    async_budget = 1,
    max_view_entries = 200,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      require('copilot_cmp.comparators').prioritize,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})

-- Use buffer source for `/` and `?` (if you have cmdline enabled)
local cmdline_config = {
  mapping = cmp.mapping.preset.cmdline({
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end),
  }),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false },
  completion = {
    autocomplete = false
  }
}
cmp.setup.cmdline(':', cmdline_config)
cmp.setup.cmdline('/', cmdline_config)

-- Git commit completion
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'buffer' },
    { name = 'spell' },
  })
})

-- Markdown completion
cmp.setup.filetype('markdown', {
  sources = cmp.config.sources({
    { name = 'buffer' },
    { name = 'spell' },
    { name = 'emoji' },
    { name = 'path' },
  })
})

-- Lua completion (enhanced for Neovim config)
cmp.setup.filetype('lua', {
  sources = cmp.config.sources({
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- SQL completion
cmp.setup.filetype('sql', {
  sources = cmp.config.sources({
    { name = 'vim-dadbod-completion' },
    { name = 'buffer' },
  })
})

-- codecompanion completion
cmp.setup.filetype('codecompanion', {
  sources = cmp.config.sources({
    { name = 'codecompanion', priority = 1000 },
    { name = 'buffer',        priority = 500, max_item_count = 3 },
  })
})

-- Custom highlights
vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
vim.api.nvim_set_hl(0, 'CmpNormal', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'CmpBorder', { fg = Colors.bluish_black })
vim.api.nvim_set_hl(0, 'CmpSelection', { bg = Colors.bluish_black })
vim.api.nvim_set_hl(0, 'CmpDocNormal', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'CmpDocBorder', { fg = Colors.bluish_black })

-- Choice node navigation
vim.keymap.set('i', '<C-l>', function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { desc = 'Change choice node' })

-- Reload snippets command
vim.api.nvim_create_user_command('LuaSnipEdit', function()
  require('luasnip.loaders').edit_snippet_files()
end, { desc = 'Edit snippets' })
