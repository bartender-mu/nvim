local opencode = {}

function opencode.start()
	local path = vim.fn.expand("%:p")
	vim.cmd("!~/.opencode/bin/opencode " .. vim.fn.shellescape(path))
end

function opencode.selection()
	localvisual = vim.fn.mode() == "v"
	if visual then
		vim.cmd([['<.'>y]])
	end

	local lines = vim.api.nvim_buf_get_lines(0, vim.fn.line(".") - 1, vim.fn.line("."), false)
	local selection = table.concat(lines, "\n")

	vim.cmd("new")
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "hide"

	vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(selection, "\n"))

	vim.fn.jobstart({
		"~/.opencode/bin/opencode",
		"--attach",
		"stdio",
	}, {
		stdin_io = {
			stream = "socket",
			iov = true,
		},
		stdout_io = {
			stream = "socket",
			iov = true,
		},
		stderr_io = {
			stream = "socket",
			iov = true,
		},
		on_stdin = function(_, data)
			if data then
				vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(data, "\n"))
			end
		end,
	})
end

function opencode.ask(prompt)
	prompt = prompt or vim.fn.input("Ask opencode: ")
	if prompt == "" then
		return
	end
	vim.cmd("!~/.opencode/bin/opencode run " .. vim.fn.shellescape(prompt))
end

vim.keymap.set("n", "<leader>oa", function()
	opencode.ask()
end, { desc = "Ask opencode" })

vim.keymap.set("n", "<leader>oo", function()
	opencode.start()
end, { desc = "Open opencode" })

return opencode