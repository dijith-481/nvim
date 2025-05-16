local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",

	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 120 })
	end,
})

--TODO remove the comment from newline
autocmd("BufEnter", {
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
	desc = "Disable New Line Comment",
})

autocmd("BufEnter", {
	callback = function()
		local dot_git_path = vim.fn.finddir(".git", ".;")
		return vim.fn.fnamemodify(dot_git_path, ":h")
	end,
})

autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("todolist", { clear = true }),
	pattern = "todolist.nvim",
	callback = function()
		vim.cmd("edit ~/syncthing/notes/todolist.md")
		vim.cmd("normal! G")
	end,
	desc = "open todolist",
})
autocmd({ "TextChanged", "insertleave" }, {
	group = vim.api.nvim_create_augroup("todolistautosave", { clear = true }),
	pattern = "*todolist.md",
	callback = function()
		vim.cmd("write")
	end,
	desc = "autosave",
})

autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("dioxus-fmt", { clear = true }),
	pattern = "*.rs",
	callback = function()
		local cwd = vim.fn.getcwd()
		if vim.fn.filereadable(cwd .. "/Dioxus.toml") == 1 then
			local command = "dx fmt --file %"
			vim.cmd("silent ! " .. command)
			-- vim.notify("dx fmt", vim.log.levels.INFO, {})
		end
	end,
})
autocmd({ "FileType" }, {
	group = vim.api.nvim_create_augroup("helpquit", { clear = true }),
	pattern = { "qf", "help", "Jaq", "man" },
	callback = function()
		vim.keymap.set("n", "q", "<Cmd>close!<CR>", { silent = true, buffer = true })
		vim.api.nvim_set_option_value("buflisted", false, { buf = 0 })
	end,
})
autocmd("FileType", {
	desc = "Disable indentscope for certain filetypes",
	pattern = {
		"dashboard",
		"help",
		"leetcode.nvim",
		"man",
		"mason",
		"notify",
		"terminal",
		"toggleterm",
		"trouble",
	},
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})
local job_id = 0
vim.keymap.set("n", "<space>to", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 5)

	job_id = vim.bo.channel
end, { desc = "New Terminal" })
local current_command = ""
vim.keymap.set("n", "<space>te", function()
	current_command = vim.fn.input("Command: ")
end)

vim.keymap.set("n", "<space>tr", function()
	if current_command == "" then
		current_command = vim.fn.input("Command: ")
	end

	vim.fn.chansend(job_id, { current_command .. "\r\n" })
end)

local function RestoreCursorPosition()
	if vim.buftype == "terminal" then
		return
	end
	local ft = vim.bo.filetype
	if
		not (ft:match("commit") or ft:match("rebase"))
		and vim.fn.line("'\"") > 1
		and vim.fn.line("'\"") <= vim.fn.line("$")
	then
		vim.cmd('normal! g`"')
	end
end

autocmd({ "BufRead" }, {

	group = vim.api.nvim_create_augroup("restore-cursor", { clear = true }),
	pattern = "*",
	callback = RestoreCursorPosition,
})

autocmd({ "VimResized" }, {
	group = vim.api.nvim_create_augroup("equalsplits", { clear = true }),
	callback = function()
		local current_tab = vim.api.nvim_get_current_tabpage()
		vim.cmd("tabdo wincmd =")
		vim.api.nvim_set_current_tabpage(current_tab)
	end,
	desc = "Resize splits with terminal window",
})
