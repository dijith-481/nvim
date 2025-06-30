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
	local last_line = vim.fn.line("$")
	while end_lnum < last_line and vim.fn.foldlevel(end_lnum + 1) >= fold_level do
		end_lnum = end_lnum + 1
	end

	return start_lnum, end_lnum
end

local function get_by_level(property, level)
	if not property or not level then
		return
	end
	if not vim.islist(property) then
		return property
	end
	return property[level] or property[(#property % level)]
end

-- local function get_fold_diagnostic_severity(start_lnum, end_lnum)
-- 	local highest_severity
-- 	for l = start_lnum, end_lnum do
-- 		for _, d in ipairs(vim.diagnostic.get(0, { lnum = l - 1 })) do
-- 			if highest_severity == nil or d.severity < highest_severity then
-- 				highest_severity = d.severity
-- 			end
-- 		end
-- 		if highest_severity == vim.diagnostic.severity.ERROR then
-- 			return highest_severity
-- 		end
-- 	end
-- 	return highest_severity
-- end

local function get_line_diff_status(lnum, bufnr)
	if not package.loaded.gitsigns then
		return nil
	end
	local gs = require("gitsigns")
	local hunks = gs.get_hunks(bufnr)
	if not hunks then
		return nil
	end

	for _, hunk in ipairs(hunks) do
		if hunk.added then
			if hunk.added.count > 0 then
				if lnum >= hunk.added.start and lnum < (hunk.added.start + hunk.added.count) then
					if hunk.type == "delete" and hunk.removed.count > 1 then
						return tostring(hunk.removed.count)
					else
						return hunk.type
					end
				end
			else
				if lnum == hunk.added.start then
					if hunk.type == "delete" and hunk.removed.count > 1 then
						return tostring(hunk.removed.count)
					else
						return hunk.type
					end
				end
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
			if d.severity < highest_severity then
				highest_severity = d.severity
			end
		end
		context.diagnostic_severity = highest_severity
	end
	return context
end

local foldfn = function(args)
	if not args.rnu and not args.nu then
		return ""
	end
	if args.virtnum ~= 0 then
		return "%="
	end
	local context = get_line_context(vim.api.nvim_get_current_buf())
	local cursor_lnum = vim.fn.line(".")
	local cursor_fold_level = vim.fn.foldlevel(cursor_lnum)
	local cursor_scope_start, cursor_scope_end = get_current_fold_range(cursor_lnum, cursor_fold_level)
	local lnum = args.lnum
	local line_fold_level = vim.fn.foldlevel(lnum)
	local fold_part = "%#" .. "Bars_glow__1" .. "#" .. "  "

	if line_fold_level > 0 then
		local is_in_cursor_scope = cursor_scope_start and lnum >= cursor_scope_start and lnum <= cursor_scope_end

		local active_scope_hl_group = is_in_cursor_scope and ("Bars_glow_" .. (cursor_fold_level - 1) % 5)
			or "Bars_glow__1"
		local self_level_hl_group = is_in_cursor_scope and "Bars_glow_" .. (line_fold_level - 1) % 5 or "Bars_glow__1"

		local active_scope_hl = "%#" .. active_scope_hl_group .. "#"
		local self_level_hl = "%#" .. self_level_hl_group .. "#"

		if vim.fn.foldclosed(lnum) == lnum then
			local icons = { "● ", "┿❭", "╪❭" }
			fold_part = self_level_hl .. get_by_level(icons, line_fold_level)
		elseif vim.fn.foldclosed(lnum) == -1 then
			local text = {
				opened_first = { first = "╭", second = "•" },
				opened_special = { first = "╭", second = "•" },
				opened_normal = { first = "├", second = "•" },
				edge_first = { first = "╰", second = "›" },
				edge_special = { first = "╰", second = "›" },
				edge_normal = { first = "│", second = " " },
				scope = { "│", "┆", "┊" },
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
					fold_part = active_scope_hl .. icon_set.first .. _G.diff_icon(context.diff_status)
				end
			else
				local base_icon
				if vim.fn.foldclosed(cursor_lnum) ~= -1 then
					local hl_group = is_in_cursor_scope and ("Bars_glow_" .. (cursor_fold_level - 2) % 5)
						or "Bars_glow__1"
					local hl = "%#" .. hl_group .. "#"
					base_icon = hl .. get_by_level(text.scope, line_fold_level)
				else
					base_icon = active_scope_hl .. get_by_level(text.scope, line_fold_level)
				end
				fold_part = base_icon .. _G.diff_icon(context.diff_status)
			end
		end
	else
		fold_part = " " .. _G.diff_icon(context.diff_status)
	end
	return fold_part
end

function _G.diff_icon(diff_status)
	if diff_status then
		local diff_icons = {
			add = "₊",
			change = "ₒ",
			delete = "˯",
		}
		local nums = {
			"₁",
			"₂",
			"₃",
			"₄",
			"₅",
			"₆",
			"₇",
			"₈",
			"₉",
			"ₓ",
		}
		local diff_hls = { add = "GitSignsAdd", change = "GitSignsChange", delete = "GitSignsDelete" }
		local num = tonumber(diff_status)
		if num ~= nil then
			return ("%#" .. "#") .. nums[math.min(num, #nums)]
		end
		return ("%#" .. diff_hls[diff_status] .. "#") .. diff_icons[diff_status]
	else
		return " "
	end
end

local lineNrFn = function(args, segment)
	if args.sclnu and segment.sign and segment.sign.wins[args.win].signs[args.lnum] then
		return "%=" .. M.signfunc(args, segment)
	end
	if not args.rnu and not args.nu then
		return ""
	end
	if args.virtnum ~= 0 then
		return "%="
	end
	local lnum = args.rnu and (args.relnum > 0 and tostring(args.relnum) or tostring(args.nu and args.lnum or 0))
		or tostring(args.lnum)

	local pad = (" "):rep(args.nuw - #lnum)
	local context = get_line_context(vim.api.nvim_get_current_buf())
	local diag_hls = {
		[vim.diagnostic.severity.ERROR] = "DiagnosticLineNrError",
		[vim.diagnostic.severity.WARN] = "DiagnosticLineNrWarn",
		[vim.diagnostic.severity.INFO] = "DiagnosticLineNrInfo",
		[vim.diagnostic.severity.HINT] = "DiagnosticLineNrHint",
	}
	local endtxt = " "
	if context.diagnostic_severity and diag_hls[context.diagnostic_severity] then
		local hl_group = diag_hls[context.diagnostic_severity]
		local rev_hl_group = diag_hls[context.diagnostic_severity] .. "Rev"
		endtxt = "%#" .. rev_hl_group .. "#"
		return "%#" .. hl_group .. "#" .. "%=" .. lnum .. endtxt
	end
	if args.relnum == 0 then
		local rev_hl_group = "CursorLineNrRev#"
		endtxt = "%#" .. rev_hl_group .. ""
		local lnum_hl_group = ""
		if context.diff_status then
			lnum_hl_group = "%#CursorLineNrBg#"
		end
		return lnum_hl_group .. "%=" .. pad .. lnum .. endtxt
	end
	return "%=" .. pad .. lnum .. " "
end

Now(function()
	Add({
		source = "luukvbaal/statuscol.nvim",
		deps = {
			"lewis6991/gitsigns.nvim",
		},
	})
	local builtin = require("statuscol.builtin")
	require("statuscol").setup({
		-- setopt = true,
		relculright = true,
		clickhandlers = {
			Lnum = builtin.gitsigns_click,
		},
		segments = {

			{
				text = { lineNrFn },
				colwidth = 1,
				click = "v:lua.ScLa",
				-- return false for oil buffer
			},
			{
				sign = {
					namespace = { ".*" },
					maxwidth = 1,
					colwidth = 1,
					auto = true,
					wrap = true,
				},
				click = "v:lua.ScSa",
			},
			{
				text = { foldfn },
				wrap = true,
				colwidth = 2,
				click = "v:lua.ScFa",
			},
		},
	})
end)
