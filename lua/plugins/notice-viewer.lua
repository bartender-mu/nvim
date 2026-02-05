-- ================================================================================================
-- TITLE : Notice Viewer Plugin Configuration
-- ABOUT : Plugin setup and keymaps for the notice capture system
-- ================================================================================================

return {
  "nvim-lua/plenary.nvim",
  name = "notice-viewer-setup", 
  event = "VeryLazy",
  config = function()
    -- Initialize notice capture system
    local capture = require("utils.notice-capture")
    local display = require("utils.notice-display")
    
    -- Initialize capture system AFTER Noice is already set up
    capture.setup()
    
    -- Global keymaps
    vim.keymap.set('n', '<leader>nv', function() display.toggle() end, 
      { noremap = true, silent = true, desc = "Toggle notice viewer" })
    
    vim.keymap.set('n', '<leader>nc', function() 
      capture.clear_notices() 
      vim.notify("All notices cleared", vim.log.levels.INFO)
    end, { noremap = true, silent = true, desc = "Clear all notices" })
    
    vim.keymap.set('n', '<leader>ns', function() 
      local capture = require("utils.notice-capture")
      local stats = capture.get_stats()
      
      vim.notify(string.format(
        "Notices: %d total | Error: %d | Warn: %d | Info: %d", 
        stats.total, 
        stats.by_level.ERROR or 0,
        stats.by_level.WARN or 0, 
        stats.by_level.INFO or 0
      ), vim.log.levels.INFO)
    end, { noremap = true, silent = true, desc = "Show notice statistics" })
    
    -- Add to FZF integration
    local ok, fzf = pcall(require, "fzf-lua")
    if ok then
      vim.keymap.set('n', '<leader>nf', function()
        local capture = require("utils.notice-capture")
        local notices = capture.get_notices()
        
        local fzf_notices = {}
        for _, notice in ipairs(notices) do
          local timestamp = os.date("%Y-%m-%d %H:%M:%S", notice.timestamp)
          local preview = string.format("[%s] [%s] %s", notice.level, notice.source, notice.message)
          table.insert(fzf_notices, timestamp .. " " .. preview)
        end
        
        fzf.fzf_exec(fzf_notices, {
          prompt = "Notices> ",
          winopts = { height = 0.4, width = 0.8 },
          actions = {
            ['default'] = function(selected)
              if selected and #selected > 0 then
                vim.notify(selected[1], vim.log.levels.INFO)
              end
            end,
            ['ctrl-e'] = function()
              -- Open in notice viewer
              display.open()
            end,
          },
        })
      end, { noremap = true, silent = true, desc = "FZF notice search" })
    end
    
    -- Auto-cleanup on VimLeave
    vim.api.nvim_create_autocmd("VimLeave", {
      callback = function()
        display.close()
      end,
    })
    
    -- Test notification on startup
    vim.defer_fn(function()
      capture.capture_notice({
        source = "system",
        level = "INFO",
        message = "Notice viewer initialized with <leader>nv",
        title = "System",
      })
    end, 2000)
  end,
}