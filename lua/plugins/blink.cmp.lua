local source_icons = {
	minuet = "󱗻",
	nvim_lsp = "",
	LSP = "󱉖",
	buffer = "",
	luasnip = "",
	Snippets = "󰅱",
	dict = "󱀽",
	path = "󰱽",
	ripgrep = "󰩫",
	git = "",
	tags = "",
	folder = "󰉖",
	-- FALLBACK
	fallback = "󰜚",
}
return {
	"saghen/blink.cmp",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"MahanRahmati/blink-nerdfont.nvim",
		"moyiz/blink-emoji.nvim",
		"niuiic/blink-cmp-rg.nvim",
		"disrupted/blink-cmp-conventional-commits",
		"xzbdmw/colorful-menu.nvim",
		"folke/snacks.nvim",
		"onsails/lspkind.nvim",
		"rafamadriz/friendly-snippets",
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			dependencies = { "rafamadriz/friendly-snippets", "mathjiajia/nvim-math-snippets" },
			config = function()
				require("luasnip").setup({
					update_events = "TextChanged,TextChangedI",
					enable_autosnippets = true,
				})
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		{
			"Kaiser-Yang/blink-cmp-dictionary",
			lazy = true,
			dependencies = { "nvim-lua/plenary.nvim" },
		},
	},

	version = "*",

	opts = {
		fuzzy = {
			sorts = {
				"exact",
				"score",
				"sort_text",
			},
			implementation = "prefer_rust_with_warning",
		},
		snippets = { preset = "luasnip" },
		completion = {
			ghost_text = { enabled = false },
			documentation = {
				window = {
					border = "single",
				},
				auto_show = true,
				auto_show_delay_ms = 500,
			},
			menu = {
				border = "single",
				-- auto_show = true,
				draw = {
					columns = { { "kind_icon", gap = 1 }, { "label", gap = 1 } },
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local kind_icon
								if ctx.source_name == "LSP" then
									kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
								elseif ctx.kind == "File" then
									kind_icon, _, _ = require("mini.icons").get("file", ctx.label)
								elseif ctx.kind == "Folder" then
									kind_icon = source_icons["folder"]
								elseif ctx.source_name == "Snippets" then
									kind_icon = source_icons[ctx.source_name]
								elseif ctx.source_name == "Nerd Fonts" then
									kind_icon = ""
								elseif ctx.source_name == "Buffer" then
									kind_icon = source_icons["buffer"]
								elseif ctx.source_name == "Dict" then
									kind_icon = source_icons["dict"]
								elseif ctx.source_name == "Ripgrep" then
									kind_icon = source_icons["ripgrep"]
								end
								return kind_icon
							end,
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
						label = {
							width = { fill = true, max = 60 },
							text = function(ctx)
								local highlights_info = require("colorful-menu").blink_highlights(ctx)
								if highlights_info ~= nil then
									return highlights_info.label
								else
									return ctx.label
								end
							end,
							highlight = function(ctx)
								local highlights = {}
								local highlights_info = require("colorful-menu").blink_highlights(ctx)
								if highlights_info ~= nil then
									highlights = highlights_info.highlights
								end
								for _, idx in ipairs(ctx.label_matched_indices) do
									table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
								end
								-- Do something else
								return highlights
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
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "mono",
		},
		sources = {
			default = {
				"lsp",
				"buffer",
				"snippets",
				"path",
				"ripgrep",
				"nerdfont",
				"emoji",
				"markdown",
				"minuet",
				"dictionary",
				"lazydev",
			},
			providers = {
				lsp = {
					name = "LSP",
					module = "blink.cmp.sources.lsp",
					override = {
						get_trigger_characters = function(self)
							local trigger_characters = self:get_trigger_characters()
							vim.list_extend(trigger_characters, { "\n", "\t", " " })
							return trigger_characters
						end,
					},
					max_items = 18,
					score_offset = 51,
				},
				path = {
					opts = {
						get_cwd = function(_)
							return vim.fn.getcwd()
						end,
					},
					score_offset = 53,
				},
				snippets = {
					score_offset = 40,
				},
				buffer = {
					score_offset = 19,
					max_items = 6,
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
				markdown = {
					name = "RenderMarkdown",
					module = "render-markdown.integ.blink",
					score_offset = 200,
					fallbacks = { "lsp" },
				},
				ripgrep = {
					module = "blink-cmp-rg",
					name = "Ripgrep",

					max_items = 8,
					---@type blink-cmp-rg.Options
					opts = {
						prefix_min_len = 4,
						get_command = function(context, prefix)
							return {
								"rg",
								"--no-config",
								"--json",
								"--word-regexp",
								"--ignore-case",
								"--",
								prefix .. "[\\w_-]+",
								vim.fn.getcwd(),
							}
						end,
						get_prefix = function(context)
							return context.line:sub(1, context.cursor[2]):match("[%w_-]+$") or ""
						end,
					},
					score_offset = 40,
				},
				minuet = {
					name = "minuet",
					module = "minuet.blink",
					score_offset = 40,
					async = true,
				},
				nerdfont = {
					module = "blink-nerdfont",
					name = "Nerd Fonts",
					score_offset = 30,
					max_items = 18,
					opts = { insert = true },
				},
				conventional_commits = {
					name = "Conventional Commits",
					module = "blink-cmp-conventional-commits",
					enabled = function()
						return vim.bo.filetype == "gitcommit"
					end,
					---@module 'blink-cmp-conventional-commits'
					---@type blink-cmp-conventional-commits.Options
					opts = {},
				},
				emoji = {
					max_items = 8,
					module = "blink-emoji",
					name = "Emoji",
					score_offset = 14,
					opts = { insert = true, max_items = 5 },
					-- should_show_items = function()
					-- 	return vim.o.filetype == "text" or vim.o.filetype == "markdown"
					-- end,
				},

				dictionary = {
					module = "blink-cmp-dictionary",
					name = "Dict",
					async = true,
					score_offset = 10,
					min_keyword_length = 5,
					max_items = 8,
					opts = {
						dictionary_files = {
							vim.fn.expand("~/.config/nvim/lua/dictionary/words.txt"),
						},
					},
				},
			},
		},
	},
	opts_extend = { "sources.default" },
}
