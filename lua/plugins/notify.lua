return {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	config = function()
		local notify = require("notify")

		notify.setup({
			background_colour = "#000000", -- Üê REQUIRED: base for blending
			fps = 60,
			level = 2,
			minimum_width = 50,
			render = "default",
			stages = "fade_in_slide_out",
			timeout = 3000,
			top_down = false,
		})

		-- Make the floating window fully transparent
		vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "none" })
		vim.api.nvim_set_hl(0, "NotifyINFOBody", { bg = "none" })
		vim.api.nvim_set_hl(0, "NotifyWARNBody", { bg = "none" })
		vim.api.nvim_set_hl(0, "NotifyERRORBody", { bg = "none" })
		vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { bg = "none" })
		vim.api.nvim_set_hl(0, "NotifyTRACEBody", { bg = "none" })

		-- Optional: Remove border
		vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = "#000000", bg = "none" })
		vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = "#000000", bg = "none" })
		vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = "#000000", bg = "none" })

		-- Set globally
		vim.notify = notify
	end,
}
