return {
	width = 60,
	row = nil, -- dashboard position. nil for center
	col = nil, -- dashboard position. nil for center
	autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
	-- These settings are used by some built-in sections
	preset = {
		pick = nil,
		keys = {
			{
				icon = " ",
				key = " ",
				desc = "Last Session",
				action = ":lua require('persistence').load({ last = true })",
			},
			{
				icon = " ",
				key = "r",
				desc = "Recent Files",
				action = ":lua Snacks.dashboard.pick('oldfiles')",
			},
			{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },

			{ icon = "", key = "d", desc = "daily note", action = ":ObsidianToday" },
			{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },

			{
				icon = " ",
				key = "g",
				desc = "Find Text",
				action = ":lua Snacks.dashboard.pick('live_grep')",
			},
			{
				icon = " ",
				key = "c",
				desc = "NeoVim Config",
				action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
			},
			{
				icon = " ",
				key = "h",
				desc = "Hyprland Config",
				action = ":lua Snacks.picker.pick({source='files',cwd=vim.fn.expand('$HOME/.config/hypr')})",
			},

			{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
		},
		-- Used by the `header` section
		-- 		header = [[
		-- ████🭀 ██ ███████🭇🭆🭂███🭍🬿🭦██🭀   🭅█🭛██ ████🭀  🭋████
		-- ██🭖█🭐 ██ ██     🭅█🭚   🭥█🭏🭖█🭐  🭋█🭡 ██ ██🭖█🭐  🭅█🭡██
		-- ██🭦██🭀██ █████  ██     ██🭦██🭀 🭅█🭛 ██ ██🭦██🭀🭋██🭛██
		-- ██ 🭖█🭐██ ██     🭖█🬿   🭊█🭝 🭖█🭐🭋█🭡  ██ ██ 🭖█🭐🭅█🭡 ██
		-- ██ 🭦████ ███████🭢🭧🭓███🭞🭜🭗 🭦████🭛  ██ ██ 🭦████🭛 ██
		-- ]],
		header = [[
████🭀 ██ ███████ █████████🭦██🭀   🭅█🭛██ ████🭀 ████🭀 
██🭖█🭐 ██ ██      ██     ██ 🭖█🭐  🭋█🭡 ██ ██🭖█🭐 ██🭖█🭐 
██🭦██🭀██ █████   ██     ██ 🭦██🭀 🭅█🭛 ██ ██🭦██🭀██🭦██🭀
██ 🭖█🭐██ ██      ██     ██  🭖█🭐🭋█🭡  ██ ██ 🭖█🭐██ 🭖█🭐
██ 🭦████ ███████ █████████  🭦████🭛  ██ ██ 🭦████ 🭦██🭀
btw
]],
	},
	-- item field formatters
	formats = {
		icon = function(item)
			if item.file and item.icon == "file" or item.icon == "directory" then
				return M.icon(item.file, item.icon)
			end
			return { item.icon, width = 2, hl = "icon" }
		end,
		footer = { "%s", align = "center" },
		header = { "%s", align = "center" },
		file = function(item, ctx)
			local fname = vim.fn.fnamemodify(item.file, ":~")
			fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
			if #fname > ctx.width then
				local dir = vim.fn.fnamemodify(fname, ":h")
				local file = vim.fn.fnamemodify(fname, ":t")
				if dir and file then
					file = file:sub(-(ctx.width - #dir - 2))
					fname = dir .. "/…" .. file
				end
			end
			local dir, file = fname:match("^(.*)/(.+)$")
			return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
		end,
	},
	sections = {
		{
			gap = 1,
			padding = 1,
			section = "header",
		},
		{ section = "keys", gap = 1, padding = 1 },
	},
}
