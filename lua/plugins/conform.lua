------------------------------------------------------------------
-- 3. conform.nvim – Format on Save
------------------------------------------------------------------
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" }, -- load just before save
	opts = {
		-- Format on save (with timeout)
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true, -- use LSP if no formatter found
		},

		-- Define formatters per filetype
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			markdown = { "prettier" },
			python = { "black" },
			rust = { "rustfmt" },
			go = { "goimports", "gofmt" },
			groovy = { "npm-groovy-lint" },
			Jenkinsfile = { "npm-groovy-lint" },
			sh = { "shfmt" },
			php = { "php_cs_fixer" },
			blade = { "blade-formatter" },
			-- Add more as needed
		},

		-- Optional: customize formatter args
		formatters = {
			stylua = {
				prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
			},
			prettier = {
				prepend_args = { "--single-quote", "--trailing-comma", "es5" },
			},
			php_cs_fixer = {
				command = "php-cs-fixer",
				args = {
					"fix",
					"--using-cache=no",
					"--config",
					".php-cs-fixer.php",
					"$FILENAME",
				},
				stdin = false,
			},
			blade_formatter = {
				command = "blade-formatter",
				args = { "--write", "$FILENAME" },
				stdin = false,
			},
		},
	},
}
