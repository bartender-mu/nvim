require("which-key").setup({
	triggers = { "auto" },
	win = {
		border = "single",
	},
})

local wk = require("which-key")

wk.add({
	{ "<leader>", group = "leader", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>c", desc = "Clear search", mode = "n" },
	{ "<leader>e", desc = "Toggle NvimTree", mode = "n" },
	{ "<leader>t", desc = "Toggle floating terminal", mode = "n" },
	{ "<leader>pa", desc = "Copy file path", mode = "n" },
	{ "<leader>td", desc = "Toggle diagnostics", mode = "n" },
	{ "<leader>w", desc = "Save file", mode = "n" },
	{ "<leader>q", desc = "Quit buffer", mode = "n" },
	{ "<leader>wq", desc = "Save and quit", mode = "n" },
	{ "<leader>qq", desc = "Force quit", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>f", group = "fzf", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>ff", desc = "Files", mode = "n" },
	{ "<leader>fg", desc = "Live Grep", mode = "n" },
	{ "<leader>fb", desc = "Buffers", mode = "n" },
	{ "<leader>fh", desc = "Help Tags", mode = "n" },
	{ "<leader>fx", desc = "Diagnostics Document", mode = "n" },
	{ "<leader>fX", desc = "Diagnostics Workspace", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>g", group = "goto", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>gd", desc = "Definitions", mode = "n" },
	{ "<leader>gD", desc = "Definition", mode = "n" },
	{ "<leader>gS", desc = "Definition (split)", mode = "n" },
	{ "<leader>fr", desc = "References", mode = "n" },
	{ "<leader>ft", desc = "Typedef", mode = "n" },
	{ "<leader>fs", desc = "Document symbols", mode = "n" },
	{ "<leader>fw", desc = "Workspace symbols", mode = "n" },
	{ "<leader>fi", desc = "Implementations", mode = "n" },
	{ "<leader>fd", desc = "Definitions", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>h", group = "git hunk", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "]h", desc = "Next hunk", mode = "n" },
	{ "[h", desc = "Previous hunk", mode = "n" },
	{ "<leader>hs", desc = "Stage hunk", mode = "n" },
	{ "<leader>hr", desc = "Reset hunk", mode = "n" },
	{ "<leader>hp", desc = "Preview hunk", mode = "n" },
	{ "<leader>hb", desc = "Blame line", mode = "n" },
	{ "<leader>hB", desc = "Toggle inline blame", mode = "n" },
	{ "<leader>hd", desc = "Diff this", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>b", group = "buffer", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>bn", desc = "Next buffer", mode = "n" },
	{ "<leader>bp", desc = "Previous buffer", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>s", group = "split", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>sv", desc = "Split vertically", mode = "n" },
	{ "<leader>sh", desc = "Split horizontally", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>d", group = "diagnostics", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>D", desc = "Line diagnostics", mode = "n" },
	{ "<leader>d", desc = "Cursor diagnostics", mode = "n" },
	{ "<leader>nd", desc = "Next diagnostic", mode = "n" },
	{ "<leader>pd", desc = "Previous diagnostic", mode = "n" },
	{ "<leader>dl", desc = "Show line diagnostics", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>a", group = "action", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>ca", desc = "Code action", mode = "n" },
	{ "<leader>rn", desc = "Rename", mode = "n" },
	{ "<leader>oi", desc = "Organize imports", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>x", desc = "Delete without yank", mode = "n" },
}, { mode = "n" })

wk.add({
	{ "<leader>q", desc = "Open diagnostic list", mode = "n" },
}, { mode = "n" })