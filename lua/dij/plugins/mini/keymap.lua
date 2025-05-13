require("mini.keymap").setup()
-- local map_multistep = require("mini.keymap").map_multistep
local mode = { "i", "c", "x", "s" }
local map_combo = require("mini.keymap").map_combo
map_combo(mode, "jk", "<BS><BS><Esc>")
map_combo(mode, "kj", "<BS><BS><Esc>")
map_combo("t", "jk", "<BS><BS><C-\\><C-n>")
map_combo("t", "kj", "<BS><BS><C-\\><C-n>")

vim.keymap.set("n", "<A-d>", "<cmd>lua zoom()<CR>")
