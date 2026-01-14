return {
	"kiddos/gemini.nvim",
	config = function()
		require("gemini").setup({
			-- Optional customizations (defaults shown)
			model_config = {
				model = "gemini-1.5-flash", -- O-- Or try "gemini-pro" for different behavior
        temperature = 0.10, -- Controls randomness (lower = more deterministic)
        top_k = 128,
				response_mime_type = "text/plain",
			},
			chat_config = { enabled = true }, -- nable interactive chat
			hints = {
				delay = 2000, -- D-- Delay in ms before hint generation
        insertion_key = "<S-Tab>",
			},
			completion = {
				delay = 800, -- Dde completion
				-- Blacklist certain filetypes or filenames if needed
				blacklisted_filetypes = { "lua" },
			},
			-- Add custom instructions/commands if desired
			instruction = {
				GeminiUnitTest = "Write unit tests for this code.",
				GeminiCodeReview = "Review this code for improvements.",
				GeminiCodeExplain = "Explain this code step by step.",
			},
		})
	end,
}
