-- vim.opt.foldminlines = 3
vim.opt.foldmethod = "expr"

vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.api.nvim_create_autocmd("LspAttach", {
--   desc = "User: Set LSP folding if client supports it",
--   callback = function(ctx)
--     local client = assert(vim.lsp.get_client_by_id(ctx.data.client_id))
--     if client:supports_method("textDocument/foldingRange") then
--       local win = vim.api.nvim_get_current_win()
--       vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
--     end
--   end,
-- })

local function fold_virt_text(result, s, lnum, coloff)
  if not coloff then
    coloff = 0
  end
  local text = ""
  local hl
  for i = 1, #s do
    local char = s:sub(i, i)
    local hls = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
    local _hl = hls[#hls]
    if _hl then
      local new_hl = "@" .. _hl.capture
      if new_hl ~= hl then
        table.insert(result, { text, hl })
        text = ""
        hl = nil
      end
      text = text .. char
      hl = new_hl
    else
      text = text .. char
    end
  end
  table.insert(result, { text, hl })
end

function _G.custom_foldtext()
  local start = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
  local end_str = vim.fn.getline(vim.v.foldend)
  local end_ = vim.trim(end_str)
  local result = {}
  fold_virt_text(result, start, vim.v.foldstart - 1)
  local line_count = vim.v.foldend - vim.v.foldstart
  table.insert(result, { "... ", "Delimiter" })
  table.insert(result, { tostring(line_count), "Delimiter" })
  table.insert(result, { " lines", "Delimiter" })
  fold_virt_text(result, end_, vim.v.foldend - 1, #(end_str:match("^(%s+)") or ""))
  return result
end

vim.opt.foldtext = "v:lua.custom_foldtext()"
vim.opt.fillchars = {
  fold = " ",
  foldopen = "",
  foldsep = " ",
  foldclose = "",
}
local fcs = vim.opt.fillchars:get()

-- Stolen from Akinsho
local function get_fold(lnum)
  if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then
    return ""
  end
  local fold_sym = vim.fn.foldclosed(lnum) == -1 and "%#FoldOpen#" .. fcs.foldopen or "%#FoldClose#" .. fcs.foldclose
  return fold_sym
end
