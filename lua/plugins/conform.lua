-- Optional: YAML formatter (prevents indent issues)
return 
  {
  "stevearc/conform.nvim",
  ft = "yaml",
  config = true,
  opts = {
    formatters_by_ft = {
      yaml = { "yamlfmt" },  -- Install via Mason if needed
    },
  },
}
