vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap -- for conciseness
--nohlsearch
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

--diagnostic
keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- increment/decrement numbers
keymap.set("n", "<C-s>", "<C-a>", { desc = "Increment number" }) -- increment

-- window management
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split [V]ertically" }) -- split window vertically
keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split [H]orizontally" }) -- split window horizontally
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make [E]qual" }) -- make split windows equal width & height
keymap.set("n", "<leader>ww", "<cmd>close<CR>", { desc = "[W] split" }) -- close current split window

keymap.set("n", "<leader>wt", "<cmd>tabnew<CR>", { desc = " new [T]ab" }) -- open new tab
keymap.set("n", "<leader>wW", "<cmd>tabclose<CR>", { desc = "[W]  tab" }) -- close current tab
keymap.set("n", "<leader>wn", "<cmd>tabn<CR>", { desc = "[N]ext tab" }) --  go to next tab
keymap.set("n", "<leader>wp", "<cmd>tabp<CR>", { desc = "[P]revious tab" }) --  go to previous tab
keymap.set("n", "<leader>wq", "<cmd>tabnew %<CR>", { desc = "[Q] current buffer in new tab" }) --  move current buffer to new tab

--disable arrow keys
-- keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
-- keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
-- keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
-- keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

--move fucus to window
keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<A-n>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<A-p>", "<cmd>cprev<CR>")
