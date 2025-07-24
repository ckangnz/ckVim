local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')

-- Main autopairs configuration
npairs.setup {
  disable_filetype = { "TelescopePrompt", "vim" },
  disable_in_macro = true,        -- disable when recording or executing a macro
  disable_in_visualblock = false, -- disable when insert after visual block mode
  disable_in_replace_mode = true,
  ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
  enable_moveright = true,
  enable_afterquote = true,         -- add bracket pairs after quote
  enable_check_bracket_line = true, -- check bracket in same line
  enable_bracket_in_quote = true,
  enable_abbr = false,              -- trigger abbreviation
  break_undo = true,                -- switch for basic rule break undo sequence
  check_ts = false,                 -- use treesitter for checking
  map_cr = true,                    -- map <CR> key
  map_bs = true,                    -- map the <BS> key
  map_c_h = false,                  -- map the <C-h> key to delete a pair
  map_c_w = false,                  -- map <c-w> to delete a pair if possible
}

-- Custom rules for better spacing
local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }

-- Add rule for spaces inside brackets
npairs.add_rules {
  -- Rule for a pair with left-side ' ' and right side ' '
  Rule(' ', ' ')
  -- Pair will only occur if we are inserting a space in (), [], or {}
      :with_pair(function(opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        return vim.tbl_contains({
          brackets[1][1] .. brackets[1][2],
          brackets[2][1] .. brackets[2][2],
          brackets[3][1] .. brackets[3][2]
        }, pair)
      end)
      :with_move(cond.none())
      :with_cr(cond.none())
  -- Delete the pair of spaces when the cursor is as such: ( | )
      :with_del(function(opts)
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local context = opts.line:sub(col - 1, col + 2)
        return vim.tbl_contains({
          brackets[1][1] .. '  ' .. brackets[1][2],
          brackets[2][1] .. '  ' .. brackets[2][2],
          brackets[3][1] .. '  ' .. brackets[3][2]
        }, context)
      end)
}

-- Add rules for each bracket type with proper spacing
for _, bracket in pairs(brackets) do
  npairs.add_rules {
    -- Rule for '( ' and ' )' patterns
    Rule(bracket[1] .. ' ', ' ' .. bracket[2])
        :with_pair(cond.none())
        :with_move(function(opts) return opts.char == bracket[2] end)
        :with_del(cond.none())
        :use_key(bracket[2])
    -- Handle CR properly to maintain indentation
        :replace_map_cr(function(_) return '<C-c>2xi<CR><C-c>O' end)
  }
end

-- JavaScript/TypeScript arrow function rule
npairs.add_rules {
  Rule('%(.*%)%s*%=>$', ' {  }', { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' })
      :use_regex(true)
      :set_end_pair_length(2)
}

-- Additional language-specific rules can be added here
-- For example, template literals in JavaScript/TypeScript
npairs.add_rules {
  Rule('`', '`', { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' })
}

-- Python f-string support
npairs.add_rules {
  Rule('f"', '"', 'python'),
  Rule("f'", "'", 'python'),
}
