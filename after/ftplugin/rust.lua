local bufnr = vim.api.nvim_get_current_buf()
local cmd = vim.cmd
local keymap = vim.keymap
keymap.set("n", "<leader>a", function()
  cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
  -- or vim.lsp.buf.codeAction() if you don't want grouping.
end, { silent = true, buffer = bufnr, desc = "Code [A]ction" })
keymap.set(
  "n",
  "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
  function()
    cmd.RustLsp({ "hover", "actions" })
  end,
  { silent = true, buffer = bufnr, desc = "Hover Action" }
)
keymap.set("n", "<leader>rr", function()
  cmd.RustLsp("run")
end, { silent = true, buffer = bufnr, desc = "[R]un Code" })

keymap.set("n", "<leader>lr", function()
  cmd.RustLsp("runnables")
end, { silent = true, buffer = bufnr, desc = "[L]ist [R]unnables" })

keymap.set("n", "<leader>re", function()
  cmd.RustLsp({ "run", bang = true })
end, { silent = true, buffer = bufnr, desc = "[Re]un code " })


keymap.set("n", "<leader>me", function()
  cmd.RustLsp("expandMacro")
end, { silent = true, buffer = bufnr, desc = " [M]acro [E]xpand" })

keymap.set("n", "<leader>mk", function()
  cmd.RustLsp({ "moveItem", "up" })
end, { silent = true, buffer = bufnr, desc = "[M]ove [U]p" })

keymap.set("n", "<leader>mj", function()
  cmd.RustLsp({ "moveItem", "down" })
end, { silent = true, buffer = bufnr, desc = "[M]ove [D]own" })
vim.keymap.set("n", "<space>a", "<Plug>RustHoverAction")

keymap.set("n", "<leader>ce", function()
  cmd.RustLsp("explainError")
end, { silent = true, buffer = bufnr, desc = "[C]ode [E]xplain" })
keymap.set("n", "<leader>cd", function()
  cmd.RustLsp("relatedDiagnostics")
end, { silent = true, buffer = bufnr, desc = "[C]ode [D]iagnostics" })

keymap.set("n", "<leader>cg", function()
  cmd.RustLsp("openCargo")
end, { silent = true, buffer = bufnr, desc = "Open [C]ar[G]o toml" })

keymap.set("n", "<leader>rd", function()
  cmd.RustLsp("openDocs")
end, { silent = true, buffer = bufnr, desc = "[R]ust [D]ocs" })

keymap.set("n", "<leader>pm", function()
  cmd.RustLsp("parentModule")
end, { silent = true, buffer = bufnr, desc = "[P]arent [M]odule" })
keymap.set("n", "<leader>jl", function()
  cmd.RustLsp("joinLines")
end, { silent = true, buffer = bufnr, desc = "[J]oin [L]ines" })
