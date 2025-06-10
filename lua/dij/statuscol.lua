local default_hl = "StatusColumn"
local components = {
  {
    type = "number",
    hl = { prefix = "Bars_glow_num_", from = 0, to = 9 },
  },
  {
    type = "gap",
    text = " ",
    hl = "StatusColumnGap",
  },
  {
    type = "fold",
    diag = true,
    text = {
      closed = { '⬬', '┿', '╪' },
      opened = { "╭" },
      edge = { "╰" },
      scope = { '│', '┆', '┊' },
    },
  },
  {
    type = "fold",
    diag = false,
    text = {
      closed = { ' ' },
      opened = { "•" },
      edge = { "›" },
      scope = { ' ' },
    },
  },
}


--- Gets the diff status of a line from mini.diff's cache.
---@param lnum number The line number.
---@param bufnr number The buffer number.
---@return 'add'|'change'|nil The diff status, or nil if none.
local function get_line_diff_status(lnum, bufnr)
  ---@diagnostic disable-next-line: undefined-field
  if not (_G.MiniDiff and _G.MiniDiff.get_buf_data) then return nil end

  local diff_data = _G.MiniDiff.get_buf_data(bufnr)
  if not (diff_data and diff_data.hunks) then return nil end

  for _, hunk in ipairs(diff_data.hunks) do
    if hunk.buf_count > 0 and lnum >= hunk.buf_start and lnum < (hunk.buf_start + hunk.buf_count) then
      if hunk.type == 'add' then return 'add' end
      if hunk.type == 'change' then return 'change' end
    end
  end

  return nil
end

--- Gets the most severe diagnostic for a range of lines (for closed folds).
---@param start_lnum number The starting line number of the fold.
---@param end_lnum number The ending line number of the fold.
---@return vim.diagnostic.Severity|nil The severity level, or nil if none.
local function get_fold_diagnostic_severity(start_lnum, end_lnum)
  local highest_severity = nil
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

--- Gets the display icon and highlight group for a diagnostic severity.
---@param severity vim.diagnostic.Severity The diagnostic severity level
---@return {icon: string, hl: string} A table with the icon and highlight group.
local function get_diagnostic_display(severity)
  local icons = {
    [vim.diagnostic.severity.ERROR] = "󰅚",
    [vim.diagnostic.severity.WARN]  = "󰀪",
    [vim.diagnostic.severity.INFO]  = "󰋽",
    [vim.diagnostic.severity.HINT]  = "󰌶",
  }
  local hls = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
    [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
    [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
    [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
  }
  return { icon = icons[severity], hl = hls[severity] }
end

local function returnValue(property, index)
  if property == nil or index == nil then return end
  if not vim.islist(property) then return property end
  return property[index] or property[#property]
end


local function build_gap(cfg, _)
  return (cfg.hl and ("%#" .. cfg.hl .. "#") or "") .. (cfg.text or " ")
end

local function build_number(cfg, context)
  local number_str = vim.v.relnum == 0 and tostring(vim.v.lnum) or tostring(vim.v.relnum)
  local fg_color_group, bg_color_group = nil, nil

  if context.diff_status == 'add' then
    fg_color_group = 'MiniDiffSignAdd'
  elseif context.diff_status == 'change' then
    fg_color_group = 'MiniDiffSignChange'
  else
    if cfg.hl and type(cfg.hl) == "table" then
      fg_color_group = cfg.hl.prefix .. math.min(vim.v.relnum, cfg.hl.to)
    end
  end

  if context.diagnostic_severity then
    local diag_bg_hls = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticLineNrError",
      [vim.diagnostic.severity.WARN]  = "DiagnosticLineNrWarn",
      [vim.diagnostic.severity.INFO]  = "DiagnosticLineNrInfo",
      [vim.diagnostic.severity.HINT]  = "DiagnosticLineNrHint",
    }
    bg_color_group = diag_bg_hls[context.diagnostic_severity]
  end

  local final_hl = ""
  if fg_color_group then final_hl = final_hl .. "%#" .. fg_color_group .. "#" end
  if bg_color_group then final_hl = final_hl .. "%#" .. bg_color_group .. "#" end

  return final_hl .. "%=" .. number_str .. " "
end

local function build_fold(cfg, context)
  local lnum = vim.v.lnum

  -- Priority 1: Diagnostic on the current line
  if cfg.diag and context.diagnostic_severity then
    local display = get_diagnostic_display(context.diagnostic_severity)
    return ("%#" .. display.hl .. "#") .. display.icon
  end

  -- Priority 2: Fold display logic
  local fold_level = vim.fn.foldlevel(lnum)
  if fold_level == 0 then return cfg.space or " " end

  -- Handle closed folds
  if vim.fn.foldclosed(lnum) == lnum then
    local fold_end_lnum = vim.fn.foldclosedend(lnum)
    local most_severe_in_fold = get_fold_diagnostic_severity(lnum, fold_end_lnum)

    if cfg.diag and most_severe_in_fold then
      local display = get_diagnostic_display(most_severe_in_fold)
      return ("%#" .. display.hl .. "#") .. display.icon
    else
      local icon = returnValue(cfg.text.closed, fold_level)
      local hl = "%#Bars_glow_" .. math.max(0, math.min(fold_level, 7) - 1) .. "#"
      return hl .. icon
    end
  end

  -- Handle open folds
  if vim.fn.foldclosed(lnum) == -1 then
    local hl = "%#Bars_glow_" .. math.max(0, math.min(fold_level, 7) - 1) .. "#"
    local icon
    if fold_level > vim.fn.foldlevel(lnum - 1) then
      icon = returnValue(cfg.text.opened, fold_level)
    elseif fold_level > vim.fn.foldlevel(lnum + 1) then
      icon = returnValue(cfg.text.edge, fold_level)
    else
      icon = returnValue(cfg.text.scope, fold_level)
    end
    return hl .. icon
  end

  return ""
end


function _G.GenerateMyStatusColumn()
  local lnum = vim.v.lnum
  local bufnr = vim.api.nvim_get_current_buf()

  local line_context = {
    diff_status = get_line_diff_status(lnum, bufnr),
  }

  local line_diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum - 1 })
  if #line_diagnostics > 0 then
    local highest_severity = vim.diagnostic.severity.HINT
    for _, d in ipairs(line_diagnostics) do
      ---@diagnostic disable-next-line: cast-local-type
      if d.severity < highest_severity then highest_severity = d.severity end
    end
    line_context.diagnostic_severity = highest_severity
  end

  local output = "%#" .. default_hl .. "#"
  for _, component in ipairs(components) do
    if component.type == "number" then
      output = output .. build_number(component, line_context)
    elseif component.type == "fold" then
      output = output .. build_fold(component, line_context)
    elseif component.type == "gap" then
      output = output .. build_gap(component, line_context)
    end
  end
  return output
end

vim.api.nvim_set_hl(0, "StatusColumn", { bg = "NONE" })

local group = vim.api.nvim_create_augroup("CustomStatusColumn", { clear = true })
vim.api.nvim_create_autocmd({ "WinNew", "WinEnter", "BufWinEnter" }, {
  group = group,
  pattern = "*",
  callback = function(args)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })
    if buftype == "nofile" or buftype == "prompt" or buftype == "terminal" then
      vim.opt.statuscolumn = ""
      return
    end

    vim.opt.statuscolumn = "%!v:lua._G.GenerateMyStatusColumn()"
  end,
})
