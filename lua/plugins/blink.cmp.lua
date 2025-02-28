return {

	"saghen/blink.cmp",
	dependencies = {
		"MahanRahmati/blink-nerdfont.nvim",
		"mikavilpas/blink-ripgrep.nvim",
		"xzbdmw/colorful-menu.nvim",
		"folke/lazydev.nvim",
		"folke/snacks.nvim",
		"onsails/lspkind.nvim",
		"milanglacier/minuet-ai.nvim",
		"nvim-tree/nvim-web-devicons",
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			dependencies = "rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		{
			"Kaiser-Yang/blink-cmp-dictionary",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
	},

	version = "*",

	opts = {
		snippets = { preset = "luasnip" },
		completion = {
			ghost_text = { enabled = false },
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 100,
			},
			trigger = {
				-- show_on_blocked_trigger_characters = {},
			},
			menu = {
				-- auto_show = false,
				draw = {
					treesitter = { "lsp" },
					columns = { { "kind_icon" }, { "label", gap = 1 } },
					-- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
					components = {
						label = {
							text = function(ctx)
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
							end,
						},
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local lspkind = require("lspkind")
								local icon = ctx.kind_icon
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								else
									icon = lspkind.symbolic(ctx.kind, {
										mode = "symbol",
									})
								end

								return icon .. ctx.icon_gap
							end,

							highlight = function(ctx)
								local hl = ctx.kind_hl
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										hl = dev_hl
									end
								end
								return hl
							end,
						},
					},
				},
			},
		},

		signature = { enabled = true },
		keymap = {
			preset = "default",

			["<C-k>"] = { "show_signature", "hide_signature", "fallback" },

			["<C-l>"] = { "snippet_forward", "fallback" },
			["<C-h>"] = { "snippet_backward", "fallback" },
			["<C-g>"] = {
				function(cmp)
					cmp.show({ providers = { "snippets" } })
				end,
			},
			["<A-1>"] = {
				function(cmp)
					cmp.accept({ index = 1 })
				end,
			},
			["<A-2>"] = {
				function(cmp)
					cmp.accept({ index = 2 })
				end,
			},
			["<A-3>"] = {
				function(cmp)
					cmp.accept({ index = 3 })
				end,
			},
			["<A-4>"] = {
				function(cmp)
					cmp.accept({ index = 4 })
				end,
			},
			["<A-5>"] = {
				function(cmp)
					cmp.accept({ index = 5 })
				end,
			},
			["<A-6>"] = {
				function(cmp)
					cmp.accept({ index = 6 })
				end,
			},
			["<A-7>"] = {
				function(cmp)
					cmp.accept({ index = 7 })
				end,
			},
			["<A-8>"] = {
				function(cmp)
					cmp.accept({ index = 8 })
				end,
			},
			["<A-9>"] = {
				function(cmp)
					cmp.accept({ index = 9 })
				end,
			},
			["<A-0>"] = {
				function(cmp)
					cmp.accept({ index = 10 })
				end,
			},
			["<A-y>"] = require("minuet").make_blink_map(),
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		-- },
		sources = {
			default = {
				"lsp",
				"lazydev",
				"buffer",
				"snippets",
				"path",
				"ripgrep",
				"nerdfont",
				"markdown",
				"minuet",
				"dictionary",
			},

			-- per_filetype = { md = { "markdown" } },
			providers = {
				lsp = {

					override = {
						get_trigger_characters = function(self)
							local trigger_characters = self:get_trigger_characters()
							vim.list_extend(trigger_characters, { "\n", "\t", " " })
							return trigger_characters
						end,
					},

					score_offset = 11,
				},
				path = {
					opts = {
						get_cwd = function(_)
							return vim.fn.getcwd()
						end,
					},

					score_offset = 13,
				},
				snippets = {
					score_offset = 12,
				},
				buffer = {
					score_offset = 9,
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 10,
				},
				markdown = {
					name = "RenderMarkdown",
					module = "render-markdown.integ.blink",
					fallbacks = { "lsp" },
				},
				ripgrep = {
					module = "blink-ripgrep",
					name = "Ripgrep",
					score_offset = -4,
				},
				minuet = {
					name = "minuet",
					module = "minuet.blink",
					score_offset = 2,
					async = true,
				},
				nerdfont = {
					module = "blink-nerdfont",
					name = "Nerd Fonts",
					score_offset = 0, -- Tune by preference
					opts = { insert = true }, -- Insert nerdfont icon (default) or complete its name
				},
				dictionary = {
					module = "blink-cmp-dictionary",
					name = "Dict",
					-- 3 is recommended
					async = true,

					score_offset = -1,
					min_keyword_length = 2,
					opts = {
						dictionary_files = {
							vim.fn.expand("../dictionary/words.txt"),
						},
						-- options for blink-cmp-dictionary
					},
				},
			},
		},
	},
}
