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
