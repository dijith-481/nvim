vim.o.cmdheight = 0
-- vim.opt.laststatus = 0
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
vim.opt.smartindent = true
-- vim.opt.wrap = true -- TODO
vim.o.winborder = "rounded"
-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"
-- vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.hlsearch = true
vim.opt.numberwidth = 3

-- Decrease update time
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
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2

-- Show which line your cursor is on
vim.opt.cursorline = true

-- turn off swapfile
vim.opt.swapfile = false
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 6

--termgui colors
vim.o.termguicolors = true

vim.opt.formatoptions:remove({ "c", "r", "o" })
-- vim.opt.iskeyword:append("-")
vim.opt.iskeyword:append("_")
vim.opt.iskeyword:append("-")
vim.opt.whichwrap:append("<,>,[,]")
vim.opt.diffopt:append("linematch:60") -- higher probability of  line match in diff
