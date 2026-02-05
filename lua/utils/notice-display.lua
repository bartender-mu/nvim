-- ================================================================================================
-- TITLE : Notice Display Module
-- ABOUT : Display system for captured notices in a dedicated Neovim buffer
-- ================================================================================================

local M = {}

-- Display state
local state = {
  buffer = nil,
  window = nil,
  filter = {
    level = nil,
    source = nil,
    pattern = nil,
    since = nil,
  },
  auto_refresh = true,
}

-- Window configuration
local window_config = {
  relative = "editor",
  width = math.floor(vim.o.columns * 0.8),
  height = math.floor(vim.o.lines * 0.6),
  col = math.floor(vim.o.columns * 0.1),
  row = math.floor(vim.o.lines * 0.2),
  border = "rounded",
  style = "minimal",
  title = " NOTICE VIEWER ",
  title_pos = "center",
}

-- Buffer configuration
local buffer_config = {
  modifiable = true,
  readonly = false,
  buftype = "nofile",
  swapfile = false,
  filetype = "notice-viewer",
}

-- Highlight groups setup
local function setup_highlights()
  local highlights = {
    NoticeViewerHeader = { fg = "#7aa2f7", bold = true },
    NoticeViewerTimestamp = { fg = "#565f89" },
    NoticeViewerLevelError = { fg = "#f7768e", bold = true },
    NoticeViewerLevelWarn = { fg = "#e0af68", bold = true },
    NoticeViewerLevelInfo = { fg = "#7aa2f7", bold = true },
    NoticeViewerLevelDebug = { fg = "#9ece6a", bold = true },
    NoticeViewerLevelTrace = { fg = "#565f89", bold = true },
    NoticeViewerSource = { fg = "#9d7cd8" },
    NoticeViewerTitle = { fg = "#bb9af7", italic = true },
    NoticeViewerMessage = { fg = "#c0caf5" },
    NoticeViewerFile = { fg = "#7aa2f7", underline = true },
  }
  
  for hl_name, hl_config in pairs(highlights) do
    vim.api.nvim_set_hl(0, hl_name, hl_config)
  end
end

-- Format a single notice for display
local function format_notice(notice)
  local timestamp = os.date("%Y-%m-%d %H:%M:%S", notice.timestamp)
  local level_highlight = string.format("NoticeViewerLevel%s", notice.level)
  local parts = {}
  
  -- Build the formatted line
  table.insert(parts, string.format("%s", timestamp))
  table.insert(parts, string.format("[%s]", notice.level))
  table.insert(parts, string.format("[%s]", notice.source:upper()))
  
  if notice.title and notice.title ~= "" then
    table.insert(parts, string.format("%s", notice.title))
  end
  
  if notice.file and notice.file ~= "" then
    local file_line = notice.line and string.format(":%d", notice.line) or ""
    table.insert(parts, string.format("%s%s", notice.file, file_line))
  end
  
  local prefix = table.concat(parts, " ")
  local message = notice.message:gsub("\n", " ")
  
  return string.format("%s %s", prefix, message)
end

-- Render notices to buffer
local function render_notices()
  if not state.buffer or not vim.api.nvim_buf_is_valid(state.buffer) then
    return
  end
  
  local capture = require("utils.notice-capture")
  local notices = capture.get_notices(state.filter)
  
  -- Clear buffer
  vim.api.nvim_buf_set_lines(state.buffer, 0, -1, false, {})
  
  -- Add header
  local stats = capture.get_stats()
  local header_lines = {}
  table.insert(header_lines, string.format(
    "[!] NOTICE VIEWER (Total: %d | Shown: %d | Filter: %s)                                              [+]",
    stats.total,
    #notices,
    format_filter_info()
  ))
  table.insert(header_lines, string.rep("─", 120))
  
  -- Add notices
  local notice_lines = {}
  for _, notice in ipairs(notices) do
    table.insert(notice_lines, format_notice(notice))
  end
  
  -- Set buffer content
  local all_lines = vim.list_extend(header_lines, notice_lines)
  vim.api.nvim_buf_set_lines(state.buffer, 0, -1, false, all_lines)
  
  -- Add syntax highlighting
  if state.window and vim.api.nvim_win_is_valid(state.window) then
    M.apply_syntax_highlighting()
  end
end

-- Format filter information for header
function format_filter_info()
  local filter_parts = {}
  
  if state.filter.level then
    table.insert(filter_parts, state.filter.level)
  end
  
  if state.filter.source then
    table.insert(filter_parts, state.filter.source)
  end
  
  if state.filter.pattern then
    table.insert(filter_parts, "pattern:" .. state.filter.pattern)
  end
  
  if #filter_parts == 0 then
    return "none"
  else
    return table.concat(filter_parts, ",")
  end
end

-- Apply syntax highlighting to buffer
function M.apply_syntax_highlighting()
  local buf = state.buffer
  
  -- Clear existing syntax
  vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
  
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  
  for i, line in ipairs(lines) do
    local line_num = i - 1
    
    -- Skip header lines
    if i > 2 then
      -- Timestamp (first 19 characters)
      vim.api.nvim_buf_set_extmark(buf, -1, line_num, 0, {
        end_col = 19,
        hl_group = "NoticeViewerTimestamp",
      })
      
      -- Level (in brackets)
      local level_start = line:find("%[")
      if level_start then
        local level_end = line:find("%]", level_start)
        if level_end then
          local level_text = line:sub(level_start + 1, level_end - 1)
          local level_highlight = "NoticeViewerLevel" .. level_text
          
          if vim.fn.hlexists(level_highlight) == 1 then
            vim.api.nvim_buf_set_extmark(buf, -1, line_num, level_start - 1, {
              end_col = level_end,
              hl_group = level_highlight,
            })
          end
        end
      end
      
      -- Source (in brackets)
      local source_start = line:find("%[", level_end or 1)
      if source_start then
        local source_end = line:find("%]", source_start)
        if source_end then
          vim.api.nvim_buf_set_extmark(buf, -1, line_num, source_start - 1, {
            end_col = source_end,
            hl_group = "NoticeViewerSource",
          })
        end
      end
    end
  end
end

-- Setup buffer keymaps
local function setup_buffer_keymaps()
  local opts = { noremap = true, silent = true, buffer = state.buffer }
  
  -- Navigation
  vim.keymap.set('n', 'j', 'j', opts)
  vim.keymap.set('n', 'k', 'k', opts)
  vim.keymap.set('n', '<Down>', 'j', opts)
  vim.keymap.set('n', '<Up>', 'k', opts)
  
  -- Actions
  vim.keymap.set('n', 'r', function() M.refresh() end, opts)
  vim.keymap.set('n', 'c', function() M.clear_all() end, opts)
  vim.keymap.set('n', 'f', function() M.show_filter_menu() end, opts)
  vim.keymap.set('n', 's', function() M.save_to_file() end, opts)
  vim.keymap.set('n', 'e', function() M.export_selected() end, opts)
  vim.keymap.set('n', 'y', function() M.copy_current_line() end, opts)
  
  -- Quit
  vim.keymap.set('n', 'q', function() M.close() end, opts)
  vim.keymap.set('n', '<Esc>', function() M.close() end, opts)
  vim.keymap.set('n', '<C-c>', function() M.close() end, opts)
end

-- Create or get the notice buffer
local function create_buffer()
  if state.buffer and vim.api.nvim_buf_is_valid(state.buffer) then
    return state.buffer
  end
  
  state.buffer = vim.api.nvim_create_buf(false, true)
  
  -- Set buffer options
  for opt, val in pairs(buffer_config) do
    vim.api.nvim_buf_set_option(state.buffer, opt, val)
  end
  
  -- Setup syntax highlighting
  setup_highlights()
  
  return state.buffer
end

-- Create or get the notice window
local function create_window()
  if state.window and vim.api.nvim_win_is_valid(state.window) then
    vim.api.nvim_set_win_config(state.window, {
      title = string.format(" NOTICE VIEWER (%s) ", format_filter_info()),
    })
    return state.window
  end
  
  local buf = create_buffer()
  state.window = vim.api.nvim_open_win(buf, true, window_config)
  
  -- Set window options
  vim.api.nvim_win_set_option(state.window, 'wrap', true)
  vim.api.nvim_win_set_option(state.window, 'cursorline', true)
  vim.api.nvim_win_set_option(state.window, 'number', false)
  vim.api.nvim_win_set_option(state.window, 'relativenumber', false)
  vim.api.nvim_win_set_option(state.window, 'signcolumn', 'no')
  
  return state.window
end

-- Toggle notice viewer
function M.toggle()
  if state.window and vim.api.nvim_win_is_valid(state.window) then
    M.close()
  else
    M.open()
  end
end

-- Open notice viewer
function M.open()
  create_window()
  setup_buffer_keymaps()
  render_notices()
end

-- Close notice viewer
function M.close()
  if state.window and vim.api.nvim_win_is_valid(state.window) then
    vim.api.nvim_win_close(state.window, true)
    state.window = nil
  end
end

-- Refresh display
function M.refresh()
  render_notices()
  M.show_status("Notices refreshed")
end

-- Clear all notices
function M.clear_all()
  local capture = require("utils.notice-capture")
  capture.clear_notices()
  render_notices()
  M.show_status("All notices cleared")
end

-- Show filter menu
function M.show_filter_menu()
  local items = {
    "All notices",
    "Error only",
    "Warning only", 
    "Info only",
    "LSP notices",
    "System notices",
    "Noice notices",
    "Notify notices",
    "Custom pattern",
    "Clear filters",
  }
  
  vim.ui.select(items, {
    prompt = "Filter notices:",
  }, function(choice)
    if not choice then return end
    
    if choice == "All notices" then
      state.filter = {}
    elseif choice == "Error only" then
      state.filter = { level = "ERROR" }
    elseif choice == "Warning only" then
      state.filter = { level = "WARN" }
    elseif choice == "Info only" then
      state.filter = { level = "INFO" }
    elseif choice == "LSP notices" then
      state.filter = { source = "lsp" }
    elseif choice == "System notices" then
      state.filter = { source = "system" }
    elseif choice == "Noice notices" then
      state.filter = { source = "noice" }
    elseif choice == "Notify notices" then
      state.filter = { source = "notify" }
    elseif choice == "Custom pattern" then
      vim.ui.input({ prompt = "Enter search pattern: " }, function(pattern)
        if pattern and pattern ~= "" then
          state.filter = { pattern = pattern }
        end
      end)
    elseif choice == "Clear filters" then
      state.filter = {}
    end
    
    -- Update window title
    if state.window and vim.api.nvim_win_is_valid(state.window) then
      vim.api.nvim_win_set_title(state.window, 
        string.format(" NOTICE VIEWER (%s) ", format_filter_info())
      )
    end
    
    render_notices()
  end)
end

-- Save notices to file
function M.save_to_file()
  vim.ui.input({ 
    prompt = "Save notices to: ",
    default = vim.fn.expand("~/notices.txt"),
  }, function(filename)
    if not filename or filename == "" then return end
    
    local capture = require("utils.notice-capture")
    local notices = capture.get_notices(state.filter)
    local file = io.open(filename, "w")
    
    if file then
      file:write(string.format("# Notices exported on %s\n", os.date("%Y-%m-%d %H:%M:%S")))
      file:write(string.format("# Total notices: %d\n\n", #notices))
      
      for _, notice in ipairs(notices) do
        file:write(format_notice(notice) .. "\n")
      end
      
      file:close()
      M.show_status(string.format("Notices saved to %s", filename))
    else
      M.show_status(string.format("Failed to save to %s", filename), "ERROR")
    end
  end)
end

-- Export current line
function M.export_selected()
  if not state.window then return end
  
  local line = vim.api.nvim_win_get_cursor(state.window)[1]
  local content = vim.api.nvim_buf_get_lines(state.buffer, line - 1, line, false)[1]
  
  if content and content ~= "" then
    vim.fn.setreg('"', content)
    M.show_status("Notice copied to clipboard")
  end
end

-- Copy current line
function M.copy_current_line()
  M.export_selected()
end

-- Show status message
function M.show_status(message, level)
  level = level or "INFO"
  vim.notify(message, vim.log.levels[level])
end

-- Update display if buffer is open
function M.update_if_open(new_notice)
  if state.window and vim.api.nvim_win_is_valid(state.window) then
    vim.defer_fn(function()
      render_notices()
    end, 100)
  end
end

return M