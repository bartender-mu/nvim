require("which-key").setup({
	triggers = { "auto" },
	win = {
		border = "single",
	},
})

local wk = require("which-key")

-- Groups (descriptions shown in popup)
wk.add({
	{ "<leader>", group = "leader" },
	{ "<leader>f", group = "fzf" },
	{ "<leader>g", group = "goto" },
	{ "<leader>h", group = "git hunk" },
	{ "<leader>b", group = "buffer" },
	{ "<leader>s", group = "split" },
	{ "<leader>d", group = "diagnostics" },
	{ "<leader>a", group = "action" },
})

-- Leader mappings
wk.add({
	{ "<leader>c", desc = "Clear search" },
	{ "<leader>e", desc = "Toggle NvimTree" },
	{ "<leader>t", desc = "Toggle floating terminal" },
	{ "<leader>pa", desc = "Copy file path" },
	{ "<leader>td", desc = "Toggle diagnostics" },
	{ "<leader>w", desc = "Save file" },
	{ "<leader>wq", desc = "Save and quit" },
	{ "<leader>qq", desc = "Force quit" },

	{ "<leader>ff", desc = "Files" },
	{ "<leader>fg", desc = "Live Grep" },
	{ "<leader>fb", desc = "Buffers" },
	{ "<leader>fh", desc = "Help Tags" },
	{ "<leader>fx", desc = "Diagnostics Document" },
	{ "<leader>fX", desc = "Diagnostics Workspace" },

	{ "<leader>gd", desc = "Definitions" },
	{ "<leader>gD", desc = "Definition" },
	{ "<leader>gS", desc = "Definition (split)" },
	{ "<leader>fr", desc = "References" },
	{ "<leader>ft", desc = "Typedef" },
	{ "<leader>fs", desc = "Document symbols" },
	{ "<leader>fw", desc = "Workspace symbols" },
	{ "<leader>fi", desc = "Implementations" },

	{ "<leader>bn", desc = "Next buffer" },
	{ "<leader>bp", desc = "Previous buffer" },

	{ "<leader>sv", desc = "Split vertically" },
	{ "<leader>sh", desc = "Split horizontally" },

	{ "<leader>D", desc = "Line diagnostics" },
	{ "<leader>dl", desc = "Show line diagnostics" },
	{ "<leader>nd", desc = "Next diagnostic" },
	{ "<leader>pd", desc = "Previous diagnostic" },

	{ "<leader>ca", desc = "Code action" },
	{ "<leader>rn", desc = "Rename" },
	{ "<leader>oi", desc = "Organize imports" },

	{ "<leader>x", desc = "Delete without yank" },

	{ "<leader>q", desc = "Open diagnostic list" },
})

-- Git hunk mappings (non-leader keys)
wk.add({
	{ "]h", desc = "Next hunk" },
	{ "[h", desc = "Previous hunk" },
	{ "<leader>hs", desc = "Stage hunk" },
	{ "<leader>hr", desc = "Reset hunk" },
	{ "<leader>hp", desc = "Preview hunk" },
	{ "<leader>hb", desc = "Blame line" },
	{ "<leader>hB", desc = "Toggle inline blame" },
	{ "<leader>hd", desc = "Diff this" },
})