vim.g.have_nerd_font = true
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.cmdwinheight = 8
vim.opt.copyindent = true -- TODO check
vim.opt.cursorline = true
vim.opt.debug = "" --  default value
vim.opt.diffopt:append("linematch:60") -- higher probability of  line match in diff
vim.opt.expandtab = true
vim.opt.foldclose = "" --  "|all"
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- files overwrite it so set it as autocmd
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.incsearch = true
vim.opt.iskeyword:append("-")
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.mps:append("<:>")
vim.opt.mouse = "a"
vim.opt.mousescroll = "ver:2,hor:1"
vim.opt.number = true
vim.opt.numberwidth = 3
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.showtabline = 1
-- vim.opt.signcolumn = "yes" -- TODO
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smoothscroll = true -- partially implemented
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.whichwrap:append("<,>,[,]")
vim.opt.winblend = 5
vim.opt.winborder = "rounded"
