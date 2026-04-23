local cached_branch = ""
local last_check = 0
local function git_branch()
	local now = vim.loop.now()
	if now - last_check > 5000 then
		cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
		last_check = now
	end
	if cached_branch ~= "" then
		return " \u{e725} " .. cached_branch .. " "
	end
	return ""
end

local function file_type()
	local ft = vim.bo.filetype
	local icons = {
		lua = "\u{e620} ",
		python = "\u{e73c} ",
		javascript = "\u{e74e} ",
		typescript = "\u{e628} ",
		javascriptreact = "\u{e7ba} ",
		typescriptreact = "\u{e7ba} ",
		html = "\u{e736} ",
		css = "\u{e749} ",
		scss = "\u{e749} ",
		json = "\u{e60b} ",
		markdown = "\u{e73e} ",
		vim = "\u{e62b} ",
		sh = "\u{f489} ",
		bash = "\u{f489} ",
		zsh = "\u{f489} ",
		rust = "\u{e7a8} ",
		go = "\u{e724} ",
		c = "\u{e61e} ",
		cpp = "\u{e61d} ",
		java = "\u{e738} ",
		php = "\u{e73d} ",
		ruby = "\u{e739} ",
		swift = "\u{e755} ",
		kotlin = "\u{e634} ",
		dart = "\u{e798} ",
		elixir = "\u{e62d} ",
		haskell = "\u{e777} ",
		sql = "\u{e706} ",
		yaml = "\u{f481} ",
		toml = "\u{e615} ",
		xml = "\u{f05c} ",
		dockerfile = "\u{f308} ",
		gitcommit = "\u{f418} ",
		gitconfig = "\u{f1d3} ",
		vue = "\u{fd42} ",
		svelte = "\u{e697} ",
		astro = "\u{e628} ",
	}

	if ft == "" then
		return " \u{f15b} "
	end

	return ((icons[ft] or " \u{f15b} ") .. ft)
end

local function file_size()
	local size = vim.fn.getfsize(vim.fn.expand("%"))
	if size < 0 then
		return ""
	end
	local size_str
	if size < 1024 then
		size_str = size .. "B"
	elseif size < 1024 * 1024 then
		size_str = string.format("%.1fK", size / 1024)
	else
		size_str = string.format("%.1fM", size / 1024 / 1024)
	end
	return " \u{f016} " .. size_str .. " "
end

local function mode_icon()
	local mode = vim.fn.mode()
	local modes = {
		n = " NORMAL",
		i = " INSERT",
		v = " VISUAL",
		V = " V-LINE",
		["\22"] = " V-BLOCK",
		c = " COMMAND",
		s = " SELECT",
		S = " S-LINE",
		["\19"] = " S-BLOCK",
		R = " REPLACE",
		r = " REPLACE",
		["!"] = " SHELL",
		t = " TERMINAL",
	}
	return modes[mode] or (" " .. mode)
end

local function get_mode_color()
	local mode = vim.fn.mode()
	local colors = {
		n = "#c586c0",
		i = "#98c379",
		v = "#61afef",
		V = "#61afef",
		["\22"] = "#61afef",
		c = "#e5c07b",
		s = "#c678dd",
		S = "#c678dd",
		["\19"] = "#c678dd",
		R = "#e06c75",
		r = "#e06c75",
		["!"] = "#56b6c2",
		t = "#e5c07b",
	}
	return colors[mode] or "#abb2bf"
end

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size
_G.get_mode_color = get_mode_color

local function setup_statusline_colors()
	vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#282c34", bg = "#98c379", bold = true })
	vim.api.nvim_set_hl(0, "StatusLineModeInsert", { fg = "#282c34", bg = "#e06c75", bold = true })
	vim.api.nvim_set_hl(0, "StatusLineModeVisual", { fg = "#282c34", bg = "#61afef", bold = true })
	vim.api.nvim_set_hl(0, "StatusLineModeReplace", { fg = "#282c34", bg = "#e5c07b", bold = true })
	vim.api.nvim_set_hl(0, "StatusLineModeCommand", { fg = "#282c34", bg = "#56b6c2", bold = true })
	vim.api.nvim_set_hl(0, "StatusLineFile", { fg = "#abb2bf", bg = "#21252b" })
	vim.api.nvim_set_hl(0, "StatusLineGit", { fg = "#98c379", bg = "#21252b" })
	vim.api.nvim_set_hl(0, "StatusLineFileType", { fg = "#61afef", bg = "#181a1f" })
	vim.api.nvim_set_hl(0, "StatusLinePos", { fg = "#abb2bf", bg = "#181a1f" })
	vim.api.nvim_set_hl(0, "StatusLineSep", { fg = "#3e4451", bg = "" })
end

vim.cmd([[
  highlight StatusLineBold gui=bold cterm=bold
]])

local function setup_dynamic_statusline()
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
		callback = function()
			local mode = vim.fn.mode()
			local mode_hl = "StatusLineMode"
			if mode == "i" then
				mode_hl = "StatusLineModeInsert"
			elseif mode == "v" or mode == "V" or mode == "\22" then
				mode_hl = "StatusLineModeVisual"
			elseif mode == "R" or mode == "r" then
				mode_hl = "StatusLineModeReplace"
			elseif mode == "c" then
				mode_hl = "StatusLineModeCommand"
			end

			vim.opt_local.statusline = table.concat({
				"%#StatusLineSep#",
				"╭ ",
				"%#" .. mode_hl .. "#",
				"%{v:lua.mode_icon()}",
				"%#StatusLineSep#",
				" ╮ ",
				"%#StatusLineFile#",
				"%f %h%m%r",
				"%#StatusLineSep#",
				" │ ",
				"%#StatusLineGit#",
				"%{v:lua.git_branch()}",
				"%#StatusLineSep#",
				" │ ",
				"%#StatusLineFileType#",
				"%{v:lua.file_type()}",
				"%#StatusLineSep#",
				" │ ",
				"%#StatusLinePos#",
				"%{v:lua.file_size()}",
				"%=",
				"%#StatusLineSep#",
				" ╰ ",
				"%#StatusLinePos#",
				"%l:%c ",
				"%P ",
			})
		end,
	})

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			vim.opt_local.statusline = table.concat({
				"%#StatusLineSep#  ╭ ",
				"%#StatusLineFile#",
				"%f %h%m%r",
				"%#StatusLineSep# ",
				"│ ",
				"%#StatusLineFileType#",
				"%{v:lua.file_type()}",
				"%#StatusLineSep# ",
				"│ ",
				"%#StatusLinePos#",
				"%=  %l:%c   %P ╯",
			})
		end,
	})
end

setup_statusline_colors()
setup_dynamic_statusline()