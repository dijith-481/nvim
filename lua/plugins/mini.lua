return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.pairs").setup()
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.surround").setup()
		require("mini.operators").setup()
		require("mini.cursorword").setup()
		require("mini.icons").setup()
		require("mini.tabline").setup({ show_icons = false })
		-- require("mini.indentscope").setup()
		local miniclue = require("mini.clue")
		miniclue.setup({
			window = {
				config = {},
				delay = 200,
			},
			triggers = {
				-- Leader triggers
				{ mode = "n", keys = "<Leader>" },
				{ mode = "x", keys = "<Leader>" },

				-- Built-in completion
				{ mode = "i", keys = "<C-x>" },

				-- `g` key
				{ mode = "n", keys = "g" },
				{ mode = "x", keys = "g" },

				{ mode = "n", keys = "]" },
				{ mode = "x", keys = "]" },
				{ mode = "n", keys = "[" },
				{ mode = "x", keys = "[" },

				-- Marks
				{ mode = "n", keys = "'" },
				{ mode = "n", keys = "`" },
				{ mode = "x", keys = "'" },
				{ mode = "x", keys = "`" },

				-- Registers
				{ mode = "n", keys = '"' },
				{ mode = "x", keys = '"' },
				{ mode = "i", keys = "<C-r>" },
				{ mode = "c", keys = "<C-r>" },

				-- Window commands
				{ mode = "n", keys = "<C-w>" },

				-- `z` key
				{ mode = "n", keys = "z" },
				{ mode = "x", keys = "z" },
			},

			clues = {
				-- Enhance this by adding descriptions for <Leader> mapping groups
				--
				{ mode = "n", keys = "<leader>f", desc = "[S]earch" },
				{ mode = "n", keys = "<leader>w", desc = "[W]indow" },
				{ mode = "n", keys = "<leader>h", desc = "[H]unk" },
				{ mode = "n", keys = "<leader>g", desc = "[G]it" },
				{ mode = "n", keys = "<leader>s", desc = "[S]earch" },
				{ mode = "n", keys = "<leader>t", desc = "[T]oggle" },
				miniclue.gen_clues.builtin_completion(),

				miniclue.gen_clues.g(),
				miniclue.gen_clues.marks(),
				miniclue.gen_clues.registers({ show_contents = true }),
				miniclue.gen_clues.windows(),
				miniclue.gen_clues.z(),
			},
		})
		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })
		require("mini.bracketed").setup()
		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			return "%2l:%-2v"
		end
	end,
}
