require("noice").setup({
	cmdline = {
		enabled = true,
	},
	redirect = {
		enabled = true,
		filter = { event = "msg_show" },
	},
	consume = {
		exclude = { "git", "svn" },
	},
	lsp = {
		progress = {
			enabled = true,
		},
		hover = {
			enabled = true,
		},
		signature = {
			enabled = true,
		},
	},
	message = {
		enabled = true,
	},
	notify = {
		enabled = true,
	},
	smart_move = {
		enabled = true,
	},
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
		inc_rename = true,
	},
})