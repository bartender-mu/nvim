return {
	"nvimtools/none-ls.nvim",
	opts = function(_, opts)
		local nls = require("null-ls")

		opts.sources = vim.list_extend(opts.sources or {}, {

			-- YAML
			-- nls.builtins.formatting.yamlfmt,
			nls.builtins.formatting.yamlfix,

      -- Python - Black + isort (recommended combo)
      nls.builtins.formatting.black, -- -- main formatter
			nls.builtins.formatting.isort,

			-- Align code via external prettier for JSON/YAML if needed
			nls.builtins.formatting.shfmt,
			-- PHP ⭐ (REPLACED!)
			nls.builtins.formatting.phpcbf.with({
				command = "phpcbf",
			}),

			-- JSON
			nls.builtins.formatting.prettier.with({
				extra_filetypes = { "json" },
			}),

			-- Lua
			nls.builtins.formatting.stylua,
		})
	end,
}
