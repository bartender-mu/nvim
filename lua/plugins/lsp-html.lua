return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {
          filetypes = { "html" },
          init_options = {
            provideFormatter = false, -- Let EFM format
          },
        },
      },
    },
  },
}

