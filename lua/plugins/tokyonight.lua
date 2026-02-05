return {
  "folke/tokyonight.nvim",
  name = "tokyonight",
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "night",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      integrations = {
        lualine = true,
      },
    })
    vim.cmd.colorscheme("tokyonight-night")
  end,
}