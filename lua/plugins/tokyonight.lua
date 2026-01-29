return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "night", -- storm, night, moon, day
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "transparent",
        floats = "transparent",
      },
      sidebars = { "qf", "help", "vista", "terminal", "packer" },
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
      integrations = {
        lualine = true,
      },
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}