local opts = { silent = true }

local function opt(desc, others)
  return vim.tbl_extend("force", opts, { desc = desc }, others or {})
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set
--nohlsearch
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

--diagnostic
keymap("n", "<leader>qq", vim.diagnostic.setloclist, opt("Open diagnostic [Q]uickfix list"))
keymap("n", "<C-n>", "<Cmd>silent cnext<CR>", opt("Next QF item"))
keymap("n", "<C-p>", "<Cmd>silent cprevious<CR>", opt("Prev QF item"))

-- increment/decrement numbers
keymap("n", "<C-s>", "<C-a>", opt("Increment number")) -- increment

-- window management
keymap("n", "<leader>wv", "<C-w>v", opt("Split [V]ertically"))                       -- split window vertically
keymap("n", "<leader>wh", "<C-w>s", opt("Split [H]orizontally"))                     -- split window horizontally
keymap("n", "<leader>we", "<C-w>=", opt("Make [E]qual"))                             -- make split windows equal width & height
keymap("n", "<leader>ww", "<cmd>close<CR>", opt("[W] split"))                        -- close current split window

keymap("n", "<C-q>", "<cmd>tabnew<CR>", opt(" new Tab"))                             -- open new tab
keymap("n", "<C-w>", "<cmd>tabclose<CR>", opt("close  tab"))                         -- close current tab
--TODO change
keymap("n", "<C-n>", "<cmd>tabn<CR>", opt("Next tab"))                               --  go to next tab
keymap("n", "<C-p>", "<cmd>tabp<CR>", opt("Previous tab"))                           --  go to previous tab
keymap("n", "<leader>wq", "<cmd>tabnew %<CR>", opt("[Q] current buffer in new tab")) --  move current buffer to new tab

--disable arrow keys
-- keymap("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
-- keymap("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
-- keymap("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
-- keymap("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

--move fucus to window
keymap("n", "<C-h>", "<C-w><C-h>", opt("Move focus to the left window"))
keymap("n", "<C-l>", "<C-w><C-l>", opt("Move focus to the right window"))
keymap("n", "<C-j>", "<C-w><C-j>", opt("Move focus to the lower window"))
keymap("n", "<C-k>", "<C-w><C-k>", opt("Move focus to the upper window"))

keymap("n", "<A-n>", "<cmd>cnext<CR>")
keymap("n", "<A-p>", "<cmd>cprev<CR>")
keymap("n", "<Leader>x", "<Cmd>so %<CR>", opt("Source the current file"))

keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("i", "<C-k>", "<Up>", opts)
keymap("i", "<C-j>", "<Down>", opts)
keymap("i", "<C-h>", "<Left>", opts)
keymap("i", "<C-l>", "<Right>", opts)
-- keymap("v", "p", "P", opts)

vim.keymap.set("n", "<leader>k", function()
  vim.diagnostic.open_float()
end, { desc = "Diagnostic float" })

vim.keymap.set('n', 'h', function()
  local col = vim.fn.col('.')
  if col ~= 1 then return 'h' end
  local line = vim.fn.line('.')
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then return 'h' end
  local prev_foldlevel = line > 1 and vim.fn.foldlevel(line - 1) or 0
  if foldlevel > prev_foldlevel then return 'zc' end
  return 'h'
end, { expr = true, noremap = true })
