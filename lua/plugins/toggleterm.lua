-- Place this in your lazy.nvim plugin list (usually in plugins.lua or similar)
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup{
      size = 15, -- terminal height
      open_mapping = [[<leader>t]], -- keybinding to toggle terminal
      hide_numbers = true, -- hide line numbers
      shade_terminals = true,
      shading_factor = 2, -- dim terminal background
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float", -- floating terminal
      close_on_exit = true,
      float_opts = {
        border = "single", -- single line border
        winblend = 0, -- transparency (0 = opaque)
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    }

    -- Optional keymap for normal mode toggle
    vim.api.nvim_set_keymap('n', '<leader>tt', ':ToggleTerm<CR>', { noremap = true, silent = true })
  end
}

