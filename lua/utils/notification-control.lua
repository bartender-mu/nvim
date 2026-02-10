-- ================================================================================================
-- TITLE : Notification Control Utility
-- ABOUT : Global toggle for all notification systems (Noice, nvim-notify, mini.notify)
-- USAGE : Use <leader>nt to toggle notifications on/off
-- ================================================================================================

local M = {}

-- Global state - notifications disabled by default
vim.g.notifications_enabled = false

-- Toggle all notification systems
function M.toggle_notifications()
  vim.g.notifications_enabled = not vim.g.notifications_enabled
  
  if vim.g.notifications_enabled then
    -- Show notification that notifications are now enabled
    -- Use print to avoid potential notification loops during re-enable
    print("🔔 Notifications enabled")
    
    -- Trigger re-evaluation of notification systems
    M._refresh_notification_systems()
  else
    -- Disable notifications without showing a notification (to avoid loops)
    print("🔕 Notifications disabled")
    
    -- Clear any existing notifications
    M._clear_existing_notifications()
  end
end

-- Get current notification state
function M.is_enabled()
  return vim.g.notifications_enabled
end

-- Internal function to refresh notification systems
function M._refresh_notification_systems()
  -- This function can be called to re-evaluate notification systems
  -- when the toggle state changes
  
  -- Re-initialize Noice if available
  local ok, noice = pcall(require, 'noice')
  if ok and noice._setup then
    -- Noice will automatically pick up the new state on next notification
  end
  
  -- Re-initialize nvim-notify if needed
  local ok_notify, notify = pcall(require, 'notify')
  if ok_notify and vim.g.notifications_enabled then
    -- Re-assign vim.notify if notifications are enabled
    vim.notify = notify
  elseif not vim.g.notifications_enabled then
    -- Override vim.notify with silent function
    vim.notify = function() end
  end
end

-- Clear existing notifications
function M._clear_existing_notifications()
  -- Clear Noice notifications
  local ok, noice = pcall(require, 'noice')
  if ok and noice.dismiss then
    noice.dismiss({ all = true })
  elseif ok then
    -- Fallback to command if dismiss function not available
    pcall(vim.cmd, 'Noice dismiss all')
  end
  
  -- Clear nvim-notify notifications
  local ok_notify, notify = pcall(require, 'notify')
  if ok_notify and notify.dismiss then
    notify.dismiss({ pending = true, history = true })
  elseif ok_notify then
    -- Fallback if dismiss function not available
    pcall(notify.dismiss)
  end
  
  -- Clear mini.notify notifications
  local ok_mini, mini_notify = pcall(require, 'mini.notify')
  if ok_mini and mini_notify.clear_all then
    mini_notify.clear_all()
  end
end

-- Initialize notification state
function M.setup()
  -- Set initial state based on global variable
  if not vim.g.notifications_enabled then
    -- Override vim.notify with silent function
    vim.notify = function() end
  end
  
  -- Create user command for manual toggle
  vim.api.nvim_create_user_command('NotificationsToggle', function()
    M.toggle_notifications()
  end, { desc = "Toggle all notifications on/off" })
  
  -- Create user command to check status
  vim.api.nvim_create_user_command('NotificationsStatus', function()
    local status = M.is_enabled() and "enabled" or "disabled"
    print("Notifications are " .. status)
  end, { desc = "Show notification status" })
end

return M