local function get_current_fold_range(cursor_lnum, fold_level)
  local closed_fold_start = vim.fn.foldclosed(cursor_lnum)
  if closed_fold_start ~= -1 then
    local closed_fold_level = vim.fn.foldlevel(closed_fold_start)
    cursor_lnum = closed_fold_start
    fold_level = closed_fold_level - 1
  end
  if fold_level <= 0 then
    return nil, nil
  end
  local start_lnum = cursor_lnum
  while vim.fn.foldlevel(start_lnum - 1) >= fold_level do
    start_lnum = start_lnum - 1
  end
  local end_lnum = cursor_lnum
  local last_line = vim.fn.line('$')
  while end_lnum < last_line and vim.fn.foldlevel(end_lnum + 1) >= fold_level do
    end_lnum = end_lnum + 1
  end

  return start_lnum, end_lnum
end

local function get_by_level(property, level)
  if not property or not level then return end
  if not vim.islist(property) then return property end
  return property[level] or property[(#property % level)]
end

local function get_fold_diagnostic_severity(start_lnum, end_lnum)
  local highest_severity
  for l = start_lnum, end_lnum do
    for _, d in ipairs(vim.diagnostic.get(0, { lnum = l - 1 })) do
      if highest_severity == nil or d.severity < highest_severity then
        highest_severity = d.severity
      end
    end
    if highest_severity == vim.diagnostic.severity.ERROR then return highest_severity end
  end
  return highest_severity
end

local function get_line_diff_status(lnum, bufnr)
  ---@diagnostic disable-next-line: undefined-field
  if not (_G.MiniDiff and _G.MiniDiff.get_buf_data) then return nil end
  local diff_data = _G.MiniDiff.get_buf_data(bufnr)
  if not (diff_data and diff_data.hunks) then return nil end

  for _, hunk in ipairs(diff_data.hunks) do
    if hunk.buf_count > 0 then
      if lnum >= hunk.buf_start and lnum < (hunk.buf_start + hunk.buf_count) then
        return hunk.type
      end
    else
      if lnum == math.max(1, hunk.buf_start) then
        return 'delete'
      end
    end
  end
  return nil
end

local function get_line_context(bufnr)
  local lnum = vim.v.lnum
  local context = {
    bufnr = bufnr,
    diff_status = get_line_diff_status(lnum, bufnr),
  }
  local line_diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum - 1 })
  if #line_diagnostics > 0 then
    local highest_severity = vim.diagnostic.severity.HINT
    for _, d in ipairs(line_diagnostics) do
      if d.severity < highest_severity then highest_severity = d.severity end
    end
    context.diagnostic_severity = highest_severity
  end
  return context
end

local foldfn = function()
  if vim.v.virtnum > 0 then return "  " end
  local context = get_line_context(vim.api.nvim_get_current_buf())
  local cursor_lnum = vim.fn.line('.')
  local cursor_fold_level = vim.fn.foldlevel(cursor_lnum)
  local cursor_scope_start, cursor_scope_end = get_current_fold_range(cursor_lnum, cursor_fold_level)
  local lnum = vim.v.lnum
  local line_fold_level = vim.fn.foldlevel(lnum)
  local fold_part = "%#" .. "Bars_glow__1" .. "#" .. "  "
  local diag_icons = {
    [vim.diagnostic.severity.ERROR] = "󰅚 ",
    [vim.diagnostic.severity.WARN] = "󰀪 ",
    [vim.diagnostic.severity.INFO] = "󰋽 ",
    [vim.diagnostic.severity.HINT] = "󰌶 "
  }
  local diag_hls = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
    [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
    [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    [vim.diagnostic.severity.HINT] = "DiagnosticSignHint"
  }

  if line_fold_level > 0 then
    local is_in_cursor_scope = cursor_scope_start and lnum >= cursor_scope_start and lnum <= cursor_scope_end

    local active_scope_hl_group = is_in_cursor_scope and ("Bars_glow_" .. (cursor_fold_level - 1) % 5) or "Bars_glow__1"
    local self_level_hl_group = "Bars_glow_" .. (line_fold_level - 1) % 5

    local active_scope_hl = "%#" .. active_scope_hl_group .. "#"
    local self_level_hl = "%#" .. self_level_hl_group .. "#"


    if vim.fn.foldclosed(lnum) == lnum then
      local severity = get_fold_diagnostic_severity(lnum, vim.fn.foldclosedend(lnum))
      if severity and diag_icons[severity] then
        fold_part = ("%#" .. diag_hls[severity] .. "#") .. diag_icons[severity]
      else
        local icons = { '● ', '┿❭', '╪❭' }
        fold_part = self_level_hl .. get_by_level(icons, line_fold_level)
      end
    elseif vim.fn.foldclosed(lnum) == -1 then
      local severity = context.diagnostic_severity
      if severity and diag_icons[severity] then
        fold_part = ("%#" .. diag_hls[severity] .. "#") .. diag_icons[severity]
      else
        local text = {
          opened_first = { first = "╭", second = "•" },
          opened_special = { first = "╭", second = "•" },
          opened_normal = { first = "├", second = "•" },
          edge_first = { first = "╰", second = "›" },
          edge_special = { first = "╰", second = "›" },
          edge_normal = { first = "│", second = " " },
          scope = { '│', '┆', '┊' }
        }

        if line_fold_level > vim.fn.foldlevel(lnum - 1) then
          local is_first_level_start = (line_fold_level == 1)
          local is_active_scope_start = (lnum == cursor_scope_start)
          local icon_set
          if is_first_level_start then
            icon_set = text.opened_first
          elseif is_active_scope_start then
            icon_set = text.opened_special
          else
            icon_set = text.opened_normal
          end
          fold_part = self_level_hl .. icon_set.first .. self_level_hl .. icon_set.second
        elseif line_fold_level > vim.fn.foldlevel(lnum + 1) then
          local is_first_level_end = (vim.fn.foldlevel(lnum + 1) == 0)
          local is_active_scope_end = cursor_scope_end and (lnum == cursor_scope_end)
          local icon_set
          if is_first_level_end then
            icon_set = text.edge_first
            fold_part = active_scope_hl .. icon_set.first .. active_scope_hl .. icon_set.second
          elseif is_active_scope_end then
            icon_set = text.edge_special
            fold_part = active_scope_hl .. icon_set.first .. self_level_hl .. icon_set.second
          else
            icon_set = text.edge_normal
            fold_part = active_scope_hl .. icon_set.first .. self_level_hl .. icon_set.second
          end
        else
          local base_icon
          if vim.fn.foldclosed(cursor_lnum) ~= -1 then
            local hl_group = is_in_cursor_scope and ("Bars_glow_" .. (cursor_fold_level - 2) % 5) or
                "Bars_glow__1"
            local hl = "%#" .. hl_group .. "#"
            base_icon = hl .. get_by_level(text.scope, line_fold_level)
          else
            base_icon = active_scope_hl .. get_by_level(text.scope, line_fold_level)
          end

          if context.diff_status then
            local diff_icons = { add = "+", change = "•", delete = "˯" }
            local diff_hls = { add = "MiniDiffSignAdd", change = "MiniDiffSignChange", delete = "MiniDiffSignDelete" }
            fold_part = base_icon .. ("%#" .. diff_hls[context.diff_status] .. "#") .. diff_icons[context.diff_status]
          else
            fold_part = base_icon .. " "
          end
        end
      end
    end
  else
    local severity = context.diagnostic_severity
    if severity and diag_icons[severity] then
      fold_part = ("%#" .. diag_hls[severity] .. "#") .. diag_icons[severity]
    end
  end
  return fold_part
end

local lineNrFn = function()
  if vim.v.virtnum > 0 then return "" end
  local context = get_line_context(vim.api.nvim_get_current_buf())
  local number_str = vim.v.relnum == 0 and tostring(vim.v.lnum) or tostring(vim.v.relnum)
  local hl_group = (vim.v.relnum == 0) and "CursorLineNr" or "LineNr"
  local diff_hls = { add = "MiniDiffSignAdd", change = "MiniDiffSignChange", delete = "MiniDiffSignDelete" }
  if context.diff_status and diff_hls[context.diff_status] then
    hl_group = diff_hls[context.diff_status]
  end
  local diag_hls = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticLineNrError",
    [vim.diagnostic.severity.WARN]  = "DiagnosticLineNrWarn",
    [vim.diagnostic.severity.INFO]  = "DiagnosticLineNrInfo",
    [vim.diagnostic.severity.HINT]  = "DiagnosticLineNrHint",
  }
  if context.diagnostic_severity and diag_hls[context.diagnostic_severity] then
    hl_group = diag_hls[context.diagnostic_severity]
  end
  return "%#" .. hl_group .. "#" .. "%=" .. number_str .. " "
end

Now(function()
  Add("luukvbaal/statuscol.nvim")
  local builtin = require 'statuscol.builtin'
  require('statuscol').setup {
    -- setopt = true,
    relculright = true,
    clickhandlers = {
      Lnum = builtin.gitsigns_click,
    },
    segments = {
      {
        text = { lineNrFn, '' },
        colwidth = 1,
        click = 'v:lua.ScLa',
      },
      {
        text = { foldfn },
        wrap = true,
        colwidth = 2,
        click = 'v:lua.ScFa',
      },
    },
  }
end)
