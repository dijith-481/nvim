require("mini.keymap").setup()
-- local map_multistep = require("mini.keymap").map_multistep
local mode = { "i", "c", "x", "s" }
local map_combo = require("mini.keymap").map_combo
map_combo(mode, "jk", "<BS><BS><Esc>")
map_combo(mode, "kj", "<BS><BS><Esc>")
map_combo("t", "jk", "<BS><BS><C-\\><C-n>")
map_combo("t", "kj", "<BS><BS><C-\\><C-n>")

vim.keymap.set("n", "<A-d>", "<cmd>lua zoom()<CR>")

-- local key_opposite = {
--   h = "l",
--   j = "k",
--   k = "j",
--   l = "h",
-- }
--
-- for key, opposite_key in pairs(key_opposite) do
--   local lhs = string.rep(key, 5)
--   local opposite_lhs = string.rep(opposite_key, 5)
--
--   map_combo({ "n", "x" }, lhs, function()
--     vim.notify("Too many " .. key)
--     return opposite_lhs
--   end)
-- end
