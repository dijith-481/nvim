vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
--
vim.opt.updatetime = 250
-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 2

-- Show which line your cursor is on
vim.opt.cursorline = true

-- turn off swapfile
vim.opt.swapfile = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

--termgui colors
--
vim.o.termguicolors = true

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
end)
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
