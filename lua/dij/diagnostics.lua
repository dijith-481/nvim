local config = {
  update_in_insert = true,
  underline = { severity = vim.diagnostic.severity.ERROR },
  severity_sort = true,
  virtual_lines = {
    current_line = true,
    format = function(diagnostic)
      return _G.get_diagnostic_emoji(diagnostic) .. " " .. diagnostic.message
    end
  },
  virtual_text = {
    spacing = 2,
    prefix = function(diagnostic)
      return _G.get_diagnostic_emoji(diagnostic)
    end,

  },
}
vim.diagnostic.config(config)


function _G.get_diagnostic_emoji(diagnostic)
  if diagnostic.severity == vim.diagnostic.severity.ERROR then
    return "😡"
  elseif diagnostic.severity == vim.diagnostic.severity.WARN then
    return "😟"
  elseif diagnostic.severity == vim.diagnostic.severity.HINT then
    return "🙃"
  else
    return "😶‍🌫️"
  end
end

-- for _, sign in ipairs(signs) do
--   vim.fn.sign_define(sign.name, { text = "", numhl = sign.name })
-- end
--
-- vim.api.nvim_create_autocmd("DiagnosticChanged", {
--   callback = function()
--     vim.fn.sign_unplace("DiagnosticLineNr", { buffer = vim.api.nvim_get_current_buf() })
--     local diagnostics = vim.diagnostic.get(0)
--     table.sort(diagnostics, function(a, b)
--       return a.severity < b.severity
--     end)
--     for _, diag in ipairs(diagnostics) do
--       local lnum = diag.lnum
--       local sign_name = diag.severity == vim.diagnostic.severity.ERROR and "DiagnosticLineNrError"
--           or diag.severity == vim.diagnostic.severity.WARN and "DiagnosticLineNrWarn"
--           or diag.severity == vim.diagnostic.severity.INFO and "DiagnosticLineNrInfo"
--           or "DiagnosticLineNrHint"
--       vim.fn.sign_place(0, "DiagnosticLineNr", sign_name, vim.api.nvim_get_current_buf(), {
--         lnum = lnum + 1,
--         priority = 200,
--       })
--     end
--   end,
-- })


-- https://www.reddit.com/r/neovim/comments/1jpbc7s/disable_virtual_text_if_there_is_diagnostic_in/
local og_virt_text
local og_virt_line
vim.api.nvim_create_autocmd({ 'CursorMoved', 'DiagnosticChanged' }, {
  group = vim.api.nvim_create_augroup('diagnostic_only_virtlines', {}),
  callback = function()
    if og_virt_line == nil then
      og_virt_line = vim.diagnostic.config().virtual_lines
    end

    -- ignore if virtual_lines.current_line is disabled
    if not (og_virt_line and og_virt_line.current_line) then
      if og_virt_text then
        vim.diagnostic.config({ virtual_text = og_virt_text })
        og_virt_text = nil
      end
      return
    end

    if og_virt_text == nil then
      og_virt_text = vim.diagnostic.config().virtual_text
    end

    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

    if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = lnum })) then
      vim.diagnostic.config({ virtual_text = og_virt_text })
    else
      vim.diagnostic.config({ virtual_text = false })
    end
  end
})


vim.api.nvim_create_autocmd('ModeChanged', {
  group = vim.api.nvim_create_augroup('diagnostic_redraw', {}),
  callback = function()
    pcall(vim.diagnostic.show)
  end
})
