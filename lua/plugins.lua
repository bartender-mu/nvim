vim.pack.add({
	"https://www.github.com/lewis6991/gitsigns.nvim",
	"https://www.github.com/echasnovski/mini.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
	"https://www.github.com/nvim-tree/nvim-tree.lua",
	"https://www.github.com/nvim-tree/nvim-web-devicons",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/folke/noice.nvim",
})

local function packadd(name)
	vim.cmd("packadd " .. name)
end

return {
	load = function()
		packadd("nvim-treesitter")
		packadd("gitsigns.nvim")
		packadd("mini.nvim")
		packadd("fzf-lua")
		packadd("nvim-tree.lua")
		packadd("nvim-web-devicons")
		packadd("nvim-lspconfig")
		packadd("mason.nvim")
		packadd("efmls-configs-nvim")
		packadd("blink.cmp")
		packadd("LuaSnip")
		packadd("which-key.nvim")
		packadd("noice.nvim")
	end,
}