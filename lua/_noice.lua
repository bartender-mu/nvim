require("noice").setup({
	cmdline = {
		enabled = true,
		view = "cmdline",
	},
	popup = {
		relative = "editor",
		border = {
			style = "rounded",
		},
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
			format = { "{spinner}. {message}" },
			format_done = "{data.done} done",
			view = "mini",
		},
		hover = {
			enabled = true,
			silent = true,
		},
		signature = {
			enabled = true,
			auto_open = { enabled = true, layout = "float" },
		},
	},
	message = {
		enabled = true,
		view = "notify",
	},
	notify = {
		enabled = true,
		view = "notify",
	},
	smart_move = {
		enabled = true,
		nofile_messages = true,
	},
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
		inc_rename = true,
		lsp_doc_border = true,
	},
})