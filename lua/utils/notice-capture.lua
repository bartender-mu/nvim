-- ================================================================================================
-- TITLE : Notice Capture Module
-- ABOUT : Comprehensive notice capture system for Neovim notifications
--         Captures from Noice, nvim-notify, LSP, and traditional :messages
-- ================================================================================================

local M = {}

-- Notice storage
local notices = {}
local max_notices = 1000
local last_message_capture = 0
local message_capture_interval = 5000 -- 5 seconds

-- Notice levels
local LEVELS = {
  TRACE = 1,
  DEBUG = 2,
  INFO = 3,
  WARN = 4,
  ERROR = 5,
}

-- Map Noice levels to our levels
local function map_noice_level(noice_level)
  local level_map = {
    trace = "TRACE",
    debug = "DEBUG", 
    info = "INFO",
    warn = "WARN",
    error = "ERROR",
  }
  return level_map[noice_level] or "INFO"
end

-- Map nvim-notify levels to our levels
local function map_notify_level(notify_level)
  local level_map = {
    [vim.log.levels.TRACE] = "TRACE",
    [vim.log.levels.DEBUG] = "DEBUG",
    [vim.log.levels.INFO] = "INFO",
    [vim.log.levels.WARN] = "WARN",
    [vim.log.levels.ERROR] = "ERROR",
  }
  return level_map[notify_level] or "INFO"
end

-- Core capture function
function M.capture_notice(data)
  local notice = {
    id = #notices + 1,
    timestamp = os.time(),
    level = data.level or "INFO",
    source = data.source or "unknown",
    title = data.title or "",
    message = data.message or "",
    file = data.file or "",
    line = data.line or nil,
  }
  
  table.insert(notices, notice)
  
  -- Maintain maximum notice limit
  if #notices > max_notices then
    table.remove(notices, 1)
  end
  
  -- Trigger display update if buffer is open
  local display = require("utils.notice-display")
  display.update_if_open(notice)
  
  return notice
end

-- Initialize Noice event capture
function M.setup_noice_capture()
  local ok, noice = pcall(require, "noice")
  if not ok then
    return
  end
  
  -- Capture notifications through Noice's API if available
  if noice.api and noice.api.on_event then
    noice.api.on_event("msg_show", function(event)
      M.capture_notice({
        source = "noice",
        level = map_noice_level(event.level),
        message = event.msg,
        title = event.title,
      })
    end)
  end
  
  -- Use autocmds to capture vim.notify calls after Noice is set up
  vim.api.nvim_create_autocmd("User", {
    pattern = "NoiceMessage",
    callback = function(event)
      local data = event.data or {}
      M.capture_notice({
        source = "noice",
        level = map_noice_level(data.level) or "INFO",
        message = data.msg or "Unknown message",
        title = data.title,
      })
    end,
  })
end

-- Initialize nvim-notify wrapper
function M.setup_notify_wrapper()
  -- Don't override vim.notify - Noice already handles it
  -- Instead, capture notifications through Noice's system
  local ok, noice = pcall(require, "noice")
  if ok and noice.notify then
    local original_noice_notify = noice.notify
    
    noice.notify = function(msg, level, opts)
      M.capture_notice({
        source = "noice",
        level = map_notify_level(level),
        message = msg,
        title = opts and opts.title,
      })
      
      return original_noice_notify(msg, level, opts)
    end
  end
end

-- Capture traditional :messages output
function M.capture_messages()
  local current_time = vim.loop.hrtime()
  if current_time - last_message_capture < message_capture_interval then
    return
  end
  
  last_message_capture = current_time
  
  vim.defer_fn(function()
    local messages = vim.fn.execute("messages")
    if messages and messages ~= "" then
      local lines = vim.split(messages, "\n")
      for _, line in ipairs(lines) do
        line = vim.trim(line)
        if line ~= "" then
          M.capture_notice({
            source = "system",
            level = "INFO",
            message = line,
          })
        end
      end
    end
  end, 100)
end

-- Setup LSP diagnostic capture
function M.setup_lsp_capture()
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function(args)
      local diagnostics = args.data.diagnostics
      for _, diagnostic in ipairs(diagnostics) do
        M.capture_notice({
          source = "lsp",
          level = vim.diagnostic.severity[diagnostic.severity]:upper(),
          message = diagnostic.message,
          file = diagnostic.filename,
          line = diagnostic.lnum + 1,
        })
      end
    end,
  })
end

-- Setup periodic message capture
function M.setup_periodic_capture()
  vim.api.nvim_create_autocmd({ "BufWritePost", "CmdlineLeave", "CursorHold" }, {
    callback = function()
      M.capture_messages()
    end,
  })
end

-- Get all notices with optional filtering
function M.get_notices(filter)
  local filtered_notices = {}
  
  for _, notice in ipairs(notices) do
    local include = true
    
    if filter then
      if filter.level and filter.level ~= notice.level then
        include = false
      elseif filter.source and filter.source ~= notice.source then
        include = false
      elseif filter.since and notice.timestamp < filter.since then
        include = false
      elseif filter.pattern and not notice.message:match(filter.pattern) then
        include = false
      end
    end
    
    if include then
      table.insert(filtered_notices, notice)
    end
  end
  
  return filtered_notices
end

-- Clear all notices
function M.clear_notices()
  notices = {}
  local display = require("utils.notice-display")
  display.update_if_open()
end

-- Get notice statistics
function M.get_stats()
  local stats = {
    total = #notices,
    by_level = {},
    by_source = {},
  }
  
  for _, notice in ipairs(notices) do
    stats.by_level[notice.level] = (stats.by_level[notice.level] or 0) + 1
    stats.by_source[notice.source] = (stats.by_source[notice.source] or 0) + 1
  end
  
  return stats
end

-- Initialize all capture methods
function M.setup()
  -- Set up all capture methods
  M.setup_noice_capture()
  M.setup_notify_wrapper()
  M.setup_lsp_capture()
  M.setup_periodic_capture()
  
  -- Add some initial system notices for testing
  vim.defer_fn(function()
    M.capture_notice({
      source = "system",
      level = "INFO",
      message = "Notice capture system initialized",
      title = "System",
    })
  end, 1000)
end

return M