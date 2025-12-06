local notify = require('notify')

-- Setup nvim-notify
notify.setup({
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

-- Set as default notify function
vim.notify = notify

-- Notifications history picker with fzf-lua
local function show_notifications()
  local ok, fzf = pcall(require, 'fzf-lua')
  if not ok then
    vim.notify('fzf-lua is not available', vim.log.levels.ERROR)
    return
  end

  local history = notify.history()

  if #history == 0 then
    vim.notify('No notifications in history', vim.log.levels.INFO)
    return
  end

  -- Build a map of display text to notification
  local notif_map = {}
  local display_entries = {}

  -- Process from oldest to newest, then reverse
  for i = #history, 1, -1 do
    local notif = history[i]

    -- Get level name
    local level_name = 'INFO'
    if notif.level == vim.log.levels.TRACE or notif.level == 1 then
      level_name = 'TRACE'
    elseif notif.level == vim.log.levels.DEBUG or notif.level == 2 then
      level_name = 'DEBUG'
    elseif notif.level == vim.log.levels.INFO or notif.level == 3 then
      level_name = 'INFO'
    elseif notif.level == vim.log.levels.WARN or notif.level == 4 then
      level_name = 'WARN'
    elseif notif.level == vim.log.levels.ERROR or notif.level == 5 then
      level_name = 'ERROR'
    end

    -- Get time
    local time = 'Unknown'
    if notif.time then
      time = os.date('%H:%M:%S', notif.time)
    end

    -- Get title
    local title = 'Notification'
    if notif.title then
      if type(notif.title) == 'table' then
        title = notif.title[1] or 'Notification'
      else
        title = tostring(notif.title)
      end
    end

    -- Get message preview
    local message = ''
    if notif.message then
      if type(notif.message) == 'table' then
        message = table.concat(notif.message, ' ')
      else
        message = tostring(notif.message)
      end
    end

    local preview = message:sub(1, 50)
    if #message > 50 then
      preview = preview .. '...'
    end

    -- Create display entry
    local entry = string.format('[%s] %s: %s - %s', time, level_name, title, preview)
    table.insert(display_entries, entry)
    notif_map[entry] = notif
  end

  fzf.fzf_exec(display_entries, {
    prompt = ' Notifications ❯ ',
    winopts = {
      height = 0.85,
      width = 0.85,
    },
    previewer = false,
    actions = {
      ['default'] = function(selected)
        if not selected or #selected == 0 then
          return
        end

        local selected_text = selected[1]
        local selected_notif = notif_map[selected_text]

        if not selected_notif then
          vim.notify('Could not find notification', vim.log.levels.ERROR)
          return
        end

        -- Create popup with full notification details
        local message = {}
        if selected_notif.message then
          if type(selected_notif.message) == 'table' then
            message = selected_notif.message
          else
            message = { tostring(selected_notif.message) }
          end
        end

        local title_lines = {}
        if selected_notif.title then
          if type(selected_notif.title) == 'table' then
            for _, t in ipairs(selected_notif.title) do
              table.insert(title_lines, tostring(t))
            end
          else
            table.insert(title_lines, tostring(selected_notif.title))
          end
        else
          table.insert(title_lines, 'Notification')
        end

        local level_name = 'INFO'
        if selected_notif.level == vim.log.levels.TRACE or selected_notif.level == 1 then
          level_name = 'TRACE'
        elseif selected_notif.level == vim.log.levels.DEBUG or selected_notif.level == 2 then
          level_name = 'DEBUG'
        elseif selected_notif.level == vim.log.levels.INFO or selected_notif.level == 3 then
          level_name = 'INFO'
        elseif selected_notif.level == vim.log.levels.WARN or selected_notif.level == 4 then
          level_name = 'WARN'
        elseif selected_notif.level == vim.log.levels.ERROR or selected_notif.level == 5 then
          level_name = 'ERROR'
        end

        local time = 'Unknown'
        if selected_notif.time then
          time = os.date('%Y-%m-%d %H:%M:%S', selected_notif.time)
        end

        local content = {}

        -- Add title
        for _, title_line in ipairs(title_lines) do
          table.insert(content, title_line)
        end

        table.insert(content, '')
        table.insert(content, 'Time:  ' .. time)
        table.insert(content, 'Level: ' .. level_name)
        table.insert(content, '')
        table.insert(content, 'Message:')
        table.insert(content, '')

        for _, line in ipairs(message) do
          -- Convert to string and handle potential newlines within the line
          local line_str = tostring(line)

          -- Split by newlines if any exist
          for subline in line_str:gmatch('[^\r\n]+') do
            -- Wrap long lines
            local max_width = 100
            if #subline > max_width then
              for i = 1, #subline, max_width do
                table.insert(content, subline:sub(i, i + max_width - 1))
              end
            else
              table.insert(content, subline)
            end
          end
        end

        -- Create a buffer for the popup
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
        vim.bo[buf].modifiable = false
        vim.bo[buf].bufhidden = 'wipe'
        vim.bo[buf].filetype = 'notify-detail'

        -- Calculate window size
        local width = math.min(vim.o.columns - 4, 120)
        local height = math.min(vim.o.lines - 4, #content + 2)

        -- Center the window
        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)

        -- Open floating window
        local win = vim.api.nvim_open_win(buf, true, {
          relative = 'editor',
          width = width,
          height = height,
          row = row,
          col = col,
          style = 'minimal',
          border = 'rounded',
          title = ' Notification Details ',
          title_pos = 'center',
        })

        -- Set window options
        vim.wo[win].winhl = 'Normal:Normal,FloatBorder:FloatBorder'

        -- Close on q or <Esc>
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, nowait = true })
        vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, nowait = true })

        -- Enable yanking in the buffer
        vim.bo[buf].modifiable = true
      end,
    },
  })
end

vim.keymap.set('n', '<leader><tab>', show_notifications, { desc = 'Show notifications history' })
