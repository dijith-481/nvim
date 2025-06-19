-- local autocmd = vim.api.nvim_create_autocmd

local function autocmd(event, group, cb, pattern, desc)
  vim.api.nvim_create_autocmd(event, {
    desc = desc,
    pattern = pattern,
    group = vim.api.nvim_create_augroup(group, { clear = true }),
    callback = cb
  })
end

autocmd("TextYankPost", "highlight-yank", function()
    vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 120 })
  end
  , "*",
  "Highlight when yanking text"
)


autocmd("BufEnter", "todolist", function()
  vim.defer_fn(function()
    vim.cmd("edit ~/syncthing/notes/todolist.md")
    vim.cmd("normal! G")
  end, 100)
end
, "todolist.nvim"
, "open todolist"
)

autocmd({ "TextChanged", "insertleave" }, "todolistautosave", function()
  vim.cmd("write")
end
, "*todolist.md"
, "autosave"
)


autocmd("BufWritePost", "dioxus-fmt", function()
  local cwd = vim.fn.getcwd()
  if vim.fn.filereadable(cwd .. "/Dioxus.toml") == 1 then
    local command = "dx fmt --file %"
    vim.cmd("silent ! " .. command)
    -- vim.notify("dx fmt", vim.log.levels.INFO, {})
  end
end
)

autocmd({ "BufEnter" }, "quitnofile", function()
  if vim.bo.buftype == "nofile" then
    vim.keymap.set("n", "<Esc>", ":q<CR>", { buffer = true, silent = true })
  end
end
, { "qf", "help", "Jaq", "man" }
, "quit with <Esc> in nofile buffers"
)

autocmd({ "FileType" }, "helpquit", function()
  vim.keymap.set("n", "q", "<Cmd>close!<CR>", { silent = true, buffer = true })
  vim.api.nvim_set_option_value("buflisted", false, { buf = 0 })
end
, { "qf", "help", "Jaq", "man" }
, "disable <Esc> in help buffers"
)


autocmd("FileType", "indentscope", function()
  vim.b.miniindentscope_disable = true
end
, {
  "dashboard",
  "help",
  "leetcode.nvim",
  "man",
  "mason",
  "notify",
  "terminal",
  "toggleterm",
  "trouble",
}
, "disable indentscope for certain filetypes"
)

autocmd("TermOpen", "custom-term-open", function()
  vim.opt.number = false
  vim.opt.relativenumber = false
end
, "*"
, "set term options"
)




autocmd({ "VimResized" }, "equalsplits", function()
  local current_tab = vim.api.nvim_get_current_tabpage()
  vim.cmd("tabdo wincmd =")
  vim.api.nvim_set_current_tabpage(current_tab)
end
, "*"
, "Resize splits with terminal window"
)

autocmd("bufEnter", "remove cro", function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  "*"
  , "remove cro"
)




-- autocmd({ "BufwritePost" }, "save view on leave", function()
--     vim.cmd.mkview({ mods = { emsg_silent = true } })
--   end,
--   "*"
--   , "save view on leave"
-- )
--
--
-- autocmd({ "BufRead" }, "restore-view-on-enter", function()
--   vim.defer_fn(function()
--     if vim.bo.buftype ~= "nofile" then
--       vim.cmd.loadview({ mods = { emsg_silent = true } })
--     end
--   end, 50)
-- end
-- )


-- autocmd({ "BufRead" }, "restore-cursor",
--   function()
--     if vim.buftype == "terminal" then
--       return
--     end
--     local ft = vim.bo.filetype
--     if
--         not (ft:match("commit") or ft:match("rebase"))
--         and vim.fn.line("'\"") > 1
--         and vim.fn.line("'\"") <= vim.fn.line("$")
--     then
--       vim.cmd('normal! g`"')
--     end
--   end
--   , "*"
--   , "restore cursor position"
-- )
