local M = {}

	local diagnostic_signs = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	}
	-- Basic colors for different severity levels
	local colors = {
		Error = "#ff6d6e",
		Warn = "#fabd2a",
		Hint = "#10d98",
		Info = "#0db7ff",
	}

M.setup = function()
	vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
				[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
				[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
				[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
			},
		},
	})
end

return M
