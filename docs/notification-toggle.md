# Notification Toggle System

## Overview
A global notification control system that can toggle all notification systems (Noice, nvim-notify, mini.notify) on and off.

## Usage

### Keymap
- `<leader>nt` - Toggle notifications on/off
  - When enabled: Shows "🔔 Notifications enabled"
  - When disabled: Shows "🔕 Notifications disabled"

### Commands
- `:NotificationsToggle` - Toggle notifications on/off
- `:NotificationsStatus` - Show current notification status

### Lua API
```lua
-- Toggle notifications
require('utils.notification-control').toggle_notifications()

-- Check if notifications are enabled
local enabled = require('utils.notification-control').is_enabled()

-- Manual setup (called automatically in lazy.lua)
require('utils.notification-control').setup()
```

## Implementation Details

### Files Modified
1. **Created**: `/lua/utils/notification-control.lua` - Main toggle logic
2. **Modified**: `/lua/plugins/noice.lua` - Respects global toggle state
3. **Modified**: `/lua/plugins/notify.lua` - Only overrides vim.notify if enabled
4. **Modified**: `/lua/plugins/mini-nvim.lua` - Conditionally loads mini.notify
5. **Modified**: `/lua/config/keymaps.lua` - Added `<leader>nt` keymap
6. **Modified**: `/lua/config/lazy.lua` - Initialize notification control

### Behavior
- **Default**: Notifications are disabled on Neovim start
- **Toggle State**: Persists during Neovim session
- **Clear on Disable**: Automatically clears existing notifications when disabled
- **Visual Feedback**: Uses print() to avoid notification loops when toggling

### Notification Systems Controlled
1. **Noice.nvim** - LSP messages and UI notifications
2. **nvim-notify** - Popup notifications with transparency
3. **mini.notify** - Additional notification system

## Troubleshooting

### If notifications don't disable
- Restart Neovim to ensure all plugins pick up the new configuration
- Check status with `:NotificationsStatus`

### If keymap doesn't work
- Ensure `<leader>` is properly set (default is `\`)
- Try the command `:NotificationsToggle` instead

### Manual Reset
If you need to reset to default (enabled) state:
```lua
:lua vim.g.notifications_enabled = true
:lua require('utils.notification-control')._refresh_notification_systems()
```