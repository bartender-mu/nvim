-- ================================================================================================
-- TITLE : lualine.nvim
-- LINKS :
--   > github : https://github.com/nvim-lualine/lualine.nvim
-- ABOUT : A blazing fast and easy to configure Neovim statusline written in Lua.
-- ================================================================================================

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "catppuccin/nvim",          -- ensures the theme is available
  },
  config = function()
    require("lualine").setup({
      options = {
        theme = "catppuccin",     -- now found
        icons_enabled = true,
        section_separators = { left = "", right = "" },
        component_separators = "|",

        -- *** TRANSPARENT LUALINE ***
        -- Make every section/component background transparent
        -- (Catppuccin already respects `transparent_background = true`,
        --  but we force it here for extra safety)
        globalstatus = true,
      },

      -- OPTIONAL: explicitly set bg = "none" for every section
      sections = {
        lualine_a = {
          { "mode", separator = { left = "" }, right_padding = 2 },
        },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = {
          { "location", separator = { right = "" }, left_padding = 2 },
        },
      },

      -- Same for inactive windows
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },

      -- Add tabline to show open buffers
      tabline = {
        lualine_a = { "buffers" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "tabs" },
      },
    })

    ------------------------------------------------------------------
    -- 3. Force lualine background to be fully transparent
    ------------------------------------------------------------------
    -- Catppuccin already sets `bg = nil` when `transparent_background = true`,
    -- but some highlight groups still carry a background.  The lines below
    -- wipe it out completely.
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl or vim.api.nvim_get_hl_by_name
        local set_hl = vim.api.nvim_set_hl

        -- Normal lualine sections
        for _, group in ipairs({
          "lualine_a_normal", "lualine_b_normal", "lualine_c_normal",
          "lualine_x_normal", "lualine_y_normal", "lualine_z_normal",
          "lualine_a_insert", "lualine_b_insert", "lualine_c_insert",
          "lualine_a_visual", "lualine_b_visual", "lualine_c_visual",
          "lualine_a_replace", "lualine_b_replace", "lualine_c_replace",
          "lualine_a_command", "lualine_b_command", "lualine_c_command",
          "lualine_a_inactive", "lualine_b_inactive", "lualine_c_inactive",
        }) do
          local cur = hl(group, true)
          cur.bg = nil               -- remove background
          set_hl(0, group, cur)
        end

        -- Separator highlight groups
        for _, sep in ipairs({ "lualine_transitional", "lualine_section_separator" }) do
          local cur = hl(sep, true) or {}
          cur.bg = nil
          set_hl(0, sep, cur)
        end
      end,
    })
  end,
}

