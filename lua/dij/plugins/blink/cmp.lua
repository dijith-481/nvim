local function build_blink(params)
	vim.notify("Building blink.cmp", vim.log.levels.INFO)
	local obj = vim.system({ "cargo", "build", "--release" }, { cwd = params.path }):wait()
	if obj.code == 0 then
		vim.notify("Building blink.cmp done", vim.log.levels.INFO)
	else
		vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
	end
end
local source_icons = {
	Buffer = "󰺮",
	Snippets = "󰅴",
	Dict = "󱀽",
	Ripgrep = "󰩫",
	git = "",
	tags = "",
	omni = "󰊕",
}
Later(function()
	Add({
		source = "saghen/blink.cmp",
		depends = {
			"bydlw98/blink-cmp-env",
			"moyiz/blink-emoji.nvim",
			"MahanRahmati/blink-nerdfont.nvim",
			"mikavilpas/blink-ripgrep.nvim",
			"disrupted/blink-cmp-conventional-commits",
			"xzbdmw/colorful-menu.nvim",
			"folke/snacks.nvim",
			"Kaiser-Yang/blink-cmp-dictionary",
			"nvim-lua/plenary.nvim",
			"L3MON4D3/LuaSnip",
		},
		hooks = {
			post_install = build_blink,
			post_checkout = build_blink,
		},
		checkout = "v1.4.1",
	})
	require("blink.cmp").setup({
		fuzzy = {
			sorts = {
				"exact",
				"score",
				"sort_text",
			},
			implementation = "rust",
		},
		completion = {
			documentation = {
				window = {},
				auto_show = true,
				auto_show_delay_ms = 300,
			},
			ghost_text = { enabled = false },
			list = {
				selection = {
					preselect = true,
					auto_insert = true,
				},
			},
			menu = {
				border = "rounded",
				auto_show = true,
				draw = {
					align_to = "none",
					treesitter = { "lsp" },
					columns = { { "kind_icon", "label", gap = 1 }, { "source_name" } },
					components = {
						label_description = {
							width = { max = 30 },
							text = function(ctx)
								return ctx.label_description
							end,
							highlight = "BlinkCmpLabelDescription",
						},
						source_name = {
							text = function(ctx)
								return ctx.source_name
							end,
						},
						kind = {
							ellipsis = false,
							width = { fill = true },
							text = function(ctx)
								return ctx.kind
							end,
							highlight = function(ctx)
								return ctx.kind_hl
							end,
						},
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local kind_icon
								if ctx.source_name == "lsp" then
									kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
								elseif ctx.kind == "File" then
									kind_icon, _, _ = require("mini.icons").get("file", ctx.label)
								elseif ctx.kind == "Folder" then
									kind_icon, _, _ = require("mini.icons").get("directory", ctx.label)
								elseif ctx.source_name == "Nerd Fonts" or ctx.source_name == "Emoji" then
									kind_icon = ""
								else
									kind_icon = source_icons[ctx.source_name]
								end

								return kind_icon
							end,
							highlight = function(ctx)
								local hl
								if ctx.kind == "File" then
									_, hl, _ = require("mini.icons").get("file", ctx.label)
								elseif ctx.kind == "Folder" then
									_, hl, _ = require("mini.icons").get("directory", ctx.label)
								else
									_, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								end
								return hl
							end,
						},
						label = {
							width = { fill = false, max = 60 },
							text = function(ctx)
								local highlights_info = require("colorful-menu").blink_highlights(ctx)
								if highlights_info ~= nil then
									return highlights_info.label .. ctx.label_detail
								else
									return ctx.label .. ctx.label_detail
								end
							end,
							highlight = function(ctx)
								local highlights = {}
								local highlights_info = require("colorful-menu").blink_highlights(ctx)
								if highlights_info ~= nil then
									highlights = highlights_info.highlights
								end
								if ctx.label_detail then
									table.insert(
										highlights,
										{ #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" }
									)
								end
								for _, idx in ipairs(ctx.label_matched_indices) do
									table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
								end
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
			["<C-d>"] = { "scroll_documentation_down", "fallback" },
			["<C-f>"] = { "scroll_documentation_up", "fallback" },
			["<C-g>"] = {
				function(cmp)
					cmp.show({ providers = { "snippets" } })
				end,
			},
		},
		appearance = {
			nerd_font_variant = "mono",
		},

		snippets = {
			preset = "luasnip",
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
				"dictionary",
				-- "omni", -- casuing issues with  sql
				"env",
			},

			per_filetype = {
				markdown = { inherit_defaults = true, "markdown" },
			},

			providers = {
				env = {
					name = "Env",
					module = "blink-cmp-env",
					opts = {
						item_kind = require("blink.cmp.types").CompletionItemKind.Variable,
						show_braces = false,
						show_documentation_window = true,
					},
				},
				lsp = {
					name = "lsp",
					module = "blink.cmp.sources.lsp",
					score_offset = 90,
					-- fallbacks = { "snippets", "buffer" },
				},
				path = {
					-- opts = {
					-- get_cwd = function(_)
					-- local cwd = vim.fn.getcwd()
					-- set public as default directory in angular files
					-- if vim.fn.filereadable(cwd .. "/angular.json") == 1 then
					-- 	return cwd .. "/public"
					-- else
					-- return cwd
					-- end
					-- end,
					-- },
					fallbacks = { "snippets", "buffer" },
					score_offset = 53,
					opts = {
						trailing_slash = false,
						label_trailing_slash = true,
						-- try if i need this function
						-- get_cwd = function(context)
						-- 	return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
						-- end,
						show_hidden_files_by_default = true,
					},
				},
				snippets = { score_offset = 50 },
				buffer = {
					score_offset = 12,
					min_keyword_length = 3,
					max_items = 3,
					opts = {
						get_bufnrs = vim.api.nvim_list_bufs,
					},
				},
				markdown = {
					name = "RenderMarkdown",
					module = "render-markdown.integ.blink",
					score_offset = 200,
					fallbacks = { "lsp" },
				},
				ripgrep = {
					module = "blink-ripgrep",
					name = "Ripgrep",

					max_items = 8,
					opts = {
						prefix_min_len = 4,
						project_root_marker = ".git",
						project_root_fallback = true,
					},
					score_offset = 40,
				},
				-- minuet = {
				-- 	name = "minuet",
				-- 	module = "minuet.blink",
				-- 	score_offset = 40,
				-- 	async = true,
				-- },
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
					opts = {},
				},
				emoji = {
					max_items = 16,
					module = "blink-emoji",
					name = "Emoji",
					score_offset = 34,
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
							vim.fn.expand("~/.config/nvim/dictionary/words.txt"),
						},
					},
				},
			},
		},
	})
	local capabilities = {
		textDocument = {
			foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			},
		},
	}

	capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
	-- local capabilities = require("blink.cmp").get_lsp_capabilities()
	vim.lsp.config("*", { capabilities = capabilities })
end)
