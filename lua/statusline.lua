local cached_branch = ""
local last_check = 0
local function git_branch()
	local now = vim.loop.now()
	if now - last_check > 5000 then
		cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
		last_check = now
	end
	if cached_branch ~= "" then
		return "\u{e725} " .. cached_branch
	end
	return ""
end

local function file_type()
	local ft = vim.bo.filetype
	local icons = {
		lua = "\u{e620}",
		python = "\u{e73c}",
		javascript = "\u{e74e}",
		typescript = "\u{e628}",
		javascriptreact = "\u{e7ba}",
		typescriptreact = "\u{e7ba}",
		html = "\u{e736}",
		css = "\u{e749}",
		scss = "\u{e749}",
		json = "\u{e60b}",
		markdown = "\u{e73e}",
		vim = "\u{e62b}",
		sh = "\u{f489}",
		bash = "\u{f489}",
		zsh = "\u{f489}",
		rust = "\u{e7a8}",
		go = "\u{e724}",
		c = "\u{e61e}",
		cpp = "\u{e61d}",
		java = "\u{e738}",
		php = "\u{e73d}",
		ruby = "\u{e739}",
		swift = "\u{e755}",
		kotlin = "\u{e634}",
		dart = "\u{e798}",
		elixir = "\u{e62d}",
		haskell = "\u{e777}",
		sql = "\u{e706}",
		yaml = "\u{f481}",
		toml = "\u{e615}",
		xml = "\u{f05c}",
		dockerfile = "\u{f308}",
		gitcommit = "\u{f418}",
		gitconfig = "\u{f1d3}",
		vue = "\u{fd42}",
		svelte = "\u{e697}",
		astro = "\u{e628}",
	}
	if ft == "" then
		return "\u{f15b}"
	end
	return (icons[ft] or "\u{f15b}") .. " " .. ft
end

local function file_size()
	local size = vim.fn.getfsize(vim.fn.expand("%"))
	if size < 0 then
		return ""
	end
	if size < 1024 then
		return size .. "B"
	elseif size < 1024 * 1024 then
		return string.format("%.1fK", size / 1024)
	else
		return string.format("%.1fM", size / 1024 / 1024)
	end
end

local function mode_icon()
	local mode = vim.fn.mode()
	local modes = {
		n = "NORMAL",
		i = "INSERT",
		v = "VISUAL",
		V = "V-LINE",
		["\22"] = "V-BLOCK",
		c = "COMMAND",
		s = "SELECT",
		S = "S-LINE",
		["\19"] = "S-BLOCK",
		R = "REPLACE",
		r = "REPLACE",
		["!"] = "SHELL",
		t = "TERMINAL",
	}
	return modes[mode] or mode
end

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size

vim.cmd([[highlight StatusLineBold gui=bold cterm=bold]])

local function setup_statusline_colors()
	vim.api.nvim_set_hl(0, "StatusLineCatppuccin", { fg = "#cdd6f4", bg = "#45475a" })
	vim.api.nvim_set_hl(0, "StatusLineModeN", { fg = "#1e1e2e", bg = "#cba6f7", bold = true })
	vim.api.nvim_set_hl(0, "StatusLineModeI", { fg = "#1e1e2e", bg = "#a6e3a1", bold = true })
	vim.api.nvim_set_hl(0, "StatusLineModeV", { fg = "#1e1e2e", bg = "#89b4fa", bold = true })
	vim.api.nvim_set_hl(0, "StatusLineModeR", { fg = "#1e1e2e", bg = "#f38ba8", bold = true })
	vim.api.nvim_set_hl(0, "StatusLineModeC", { fg = "#1e1e2e", bg = "#94e2d5", bold = true })
	vim.api.nvim_set_hl(0, "StatusLineCatGit", { fg = "#1e1e2e", bg = "#a6e3a1" })
	vim.api.nvim_set_hl(0, "StatusLineCatFt", { fg = "#1e1e2e", bg = "#89b4fa" })
	vim.api.nvim_set_hl(0, "StatusLineCatPos", { fg = "#cdd6f4", bg = "#45475a" })
	vim.api.nvim_set_hl(0, "StatusLineSep", { fg = "#6c7086", bg = "" })
end

local function setup_dynamic_statusline()
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
		callback = function()
			local mode = vim.fn.mode()
			local mode_hl = "StatusLineModeN"
			if mode == "i" then
				mode_hl = "StatusLineModeI"
			elseif mode == "v" or mode == "V" or mode == "\22" then
				mode_hl = "StatusLineModeV"
			elseif mode == "R" or mode == "r" then
				mode_hl = "StatusLineModeR"
			elseif mode == "c" then
				mode_hl = "StatusLineModeC"
			end

			vim.opt_local.statusline = table.concat({
				"%#StatusLineSep#",
				"",
				"%#" .. mode_hl .. "#",
				"  %{v:lua.mode_icon()}  ",
				"%#StatusLineSep#",
				"",
				"%#StatusLineCatGit#",
				" %{v:lua.git_branch()} ",
				"%#StatusLineSep#",
				"",
				"%#StatusLineCatFt#",
				" %{v:lua.file_type()} ",
				"%#StatusLineSep#",
				"",
				"%#StatusLineCatPos#",
				"%{v:lua.file_size()} ",
				"%=",
				"%#StatusLineCatPos#",
				" %l:%c  %P ",
			})
		end,
	})

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			vim.opt_local.statusline = table.concat({
				"%#StatusLineSep# ",
				"%#StatusLineCatGit#",
				"%f %h%m%r ",
				"%#StatusLineSep#",
				"",
				"%#StatusLineCatFt#",
				" %{v:lua.file_type()} ",
				"%#StatusLineSep#",
				"",
				"%#StatusLineCatPos#",
				"%=  %l:%c   %P ",
			})
		end,
	})
end

setup_statusline_colors()
setup_dynamic_statusline()