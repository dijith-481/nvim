local opts = { silent = true }
local keymap = vim.keymap.set
local function opt(desc, others)
  return vim.tbl_extend("force", opts, { desc = desc }, others or {})
end

local function fn(func_to_call)
  return function()
    func_to_call()
  end
end

local function fold_on_h()
  local col = vim.fn.col('.')
  if col ~= 1 then return 'h' end
  local line = vim.fn.line('.')
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then return 'h' end
  local prev_foldlevel = line > 1 and vim.fn.foldlevel(line - 1) or 0
  if foldlevel > prev_foldlevel then return 'zc' end
  return 'h'
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

keymap("n", "<leader>qq", vim.diagnostic.setloclist, opt("Open diagnostic [Q]uickfix list"))
keymap("n", "<C-n>", "<Cmd>silent cnext<CR>", opt("Next QF item"))
keymap("n", "<C-p>", "<Cmd>silent cprevious<CR>", opt("Prev QF item"))

keymap("n", "<C-s>", "<C-a>", opt("Increment number"))

-- window management
keymap("n", "<leader>wv", "<C-w>v", opt("Split [V]ertically"))
keymap("n", "<leader>wh", "<C-w>s", opt("Split [H]orizontally"))
keymap("n", "<leader>we", "<C-w>=", opt("Make [E]qual"))
keymap("n", "<leader>ww", "<cmd>close<CR>", opt("[W] split"))

keymap("n", "<C-q>", "<cmd>tabnew<CR>", opt(" new Tab"))
keymap("n", "<C-w>", "<cmd>tabclose<CR>", opt("close  tab"))
keymap("n", "<C-S-q>", "<cmd>tabnew %<CR>", opt("[Q] current buffer in new tab"))

--move fucus to window
keymap("n", "<C-h>", "<C-w><C-h>", opt("Move focus to the left window"))
keymap("n", "<C-l>", "<C-w><C-l>", opt("Move focus to the right window"))
keymap("n", "<C-j>", "<C-w><C-j>", opt("Move focus to the lower window"))
keymap("n", "<C-k>", "<C-w><C-k>", opt("Move focus to the upper window"))

keymap("n", "<Leader>x", "<Cmd>so %<CR>", opt("Source the current file"))

keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("i", "<C-k>", "<Up>", opts)
keymap("i", "<C-j>", "<Down>", opts)
keymap("i", "<C-h>", "<Left>", opts)
keymap("i", "<C-l>", "<Right>", opts)

keymap("n", "<leader>k", fn(vim.diagnostic.open_float), opt("Diagnostic float"))

keymap('n', 'h', fold_on_h(), { expr = true, noremap = true })

keymap("x", "/", "<Esc>/\\%V")
keymap("n", "<leader>p", "\"_dP", opt("Paste [P]revious"))

keymap("n", "<A-1>", "<cmd>1tabn<CR>", opt("Open tab 1"))
keymap("n", "<A-2>", "<cmd>2tabn<CR>", opt("Open tab 2"))
keymap("n", "<A-3>", "<cmd>3tabn<CR>", opt("Open tab 3"))
keymap("n", "<A-4>", "<cmd>4tabn<CR>", opt("Open tab 4"))
keymap("n", "<A-5>", "<cmd>5tabn<CR>", opt("Open tab 5"))
keymap("n", "<A-6>", "<cmd>6tabn<CR>", opt("Open tab 6"))
keymap("n", "<A-7>", "<cmd>7tabn<CR>", opt("Open tab 7"))
keymap("n", "<A-8>", "<cmd>8tabn<CR>", opt("Open tab 8"))
keymap("n", "<A-9>", "<cmd>9tabn<CR>", opt("Open tab 9"))
keymap("n", "<A-0>", "<cmd>tablast<CR>", opt("Open last tab"))

--disable arrow keys
-- keymap("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
-- keymap("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
-- keymap("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
-- keymap("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

local job_id = 0
keymap("n", "<space>to", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 5)

  job_id = vim.bo.channel
end, { desc = "New Terminal" })
local current_command = ""
keymap("n", "<space>te", function()
  current_command = vim.fn.input("Command: ")
end)

keymap("n", "<space>tr", function()
  if current_command == "" then
    current_command = vim.fn.input("Command: ")
  end

  vim.fn.chansend(job_id, { current_command .. "\r\n" })
end)
