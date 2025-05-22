local gettreesitter = function()
	local treesitter = require("nvim-treesitter").statusline()
	if treesitter ~= nil then
		return treesitter:sub(1, 200)
	else
		return ""
	end
end
local statusline = require("mini.statusline")
local visible = function()
	local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 1000 })
	local git = MiniStatusline.section_git({ trunc_width = 40 })
	local diff = MiniStatusline.section_diff({ trunc_width = 75 })
	local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
	local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
	local filename = MiniStatusline.section_filename({ trunc_width = 140 })
	local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
	local location = MiniStatusline.section_location({ trunc_width = 75 })
	local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
	local treesitter = gettreesitter()

	return MiniStatusline.combine_groups({
		{ hl = mode_hl, strings = { mode } },
		{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
		"%<", -- Mark general truncate point
		{ hl = "MiniStatuslineFilename", strings = { filename } },
		{ hl = "MiniStatuslineTreesitter", strings = { treesitter } },
		"%=", -- End left alignment
		{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
		{ hl = mode_hl, strings = { search, location } },
	})
end
require("mini.statusline").setup({ content = { active = visible, inactive = visible } })
require("mini.bracketed").setup()
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
	return "%2l:%-2v"
end
