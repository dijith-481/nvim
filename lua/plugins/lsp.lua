return {
	{
		"folke/lazydev.nvim",
		lazy = true,
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", ft = "lua" },
	{
		"neovim/nvim-lspconfig",

		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"saghen/blink.nvim",
			{ "williamboman/mason.nvim", opts = {
				modifiableness = true,
			} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			{
				"luckasRanarison/tailwind-tools.nvim",
				name = "tailwind-tools",
				build = ":UpdateRemotePlugins",
				dependencies = {
					"nvim-treesitter/nvim-treesitter",
				},
				opts = {
					filetypes = {
						"templ",
						"vue",
						"html",
						"astro",
						"javascript",
						"typescript",
						"react",
						"htmlangular",
					},
				}, -- your configuration
			},
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			require("lspconfig").lua_ls.setup({ capabilities = capabilities })
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Inlay [H]ints")
					end
				end,
			})

			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,

					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local servers = {
				angularls = {},
				bashls = {},
				hyprls = {},
				clangd = {},
				-- gopls = {},
				efm = {},
				basedpyright = {
					enabled = true,
					settings = {
						basedpyright = {
							disableOrganizeImports = true,
							typeCheckingMode = "off",
						},
					},
				},
				ruff = {
					on_attach = function(client, bufnr)
						client.server_capabilities.disableHoverProvider = false

						vim.api.nvim_create_user_command("RuffAutoFix", function()
							vim.lsp.buf.execute_command({
								command = "ruff.applyAutofix",
								arguments = {
									{ uri = vim.uri_from_bufnr(0) },
								},
							})
						end, { desc = "Ruff: Fix all auto-fixable problems" })

						vim.api.nvim_create_user_command("RuffOrganizeImports", function()
							vim.lsp.buf.execute_command({
								command = "ruff.applyOrganizeImports",
								arguments = {
									{ uri = vim.uri_from_bufnr(0) },
								},
							})
						end, { desc = "Ruff: Format imports" })
					end,
				},
				rust_analyzer = {
					capabilities = { capabilities },
					completion = {
						capable = {
							snippets = "add_parenthesis",
						},
					},
				},
				emmet_language_server = {
					filetypes = {
						"css",
						"eruby",
						"html",
						"htmldjango",
						"javascriptreact",
						"less",
						"pug",
						"sass",
						"scss",
						"typescriptreact",
					},
				},
				-- tailwindcss = {
				-- 	filetypes = {
				-- 		"templ",
				-- 		"vue",
				-- 		"html",
				-- 		"astro",
				-- 		"javascript",
				-- 		"typescript",
				-- 		"react",
				-- 		"htmlangular",
				-- 	},
				-- },
				ts_ls = {

					capabilities = { capabilities },
					settings = {
						format = { enable = true },
						-- disable unused vars hint
						-- diagnostics = { ignoredCodes = { 6133, 2304 } },
					},
				},
				marksman = {},
				stylelint_lsp = {},
				--

				lua_ls = {
					-- cmd = { ... },
					-- filetypes = { ... },
					capabilities = { capabilities },
					settings = {
						Lua = {
							completion = {
								callSnippet = "Disable",
								keywordSnippet = "Disable",
							},
							diagnostics = { disable = { "missing-fields" } },
						},
					},
				},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"ruff",
				"basedpyright",
				"prettier",
				"rust_analyzer",
				"stylelint",
				"stylelint_lsp",
				"emmet_language_server",
				"ts_ls",
				"marksman",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("lspconfig").fish_lsp.setup({
				cmd = { "fish-lsp", "start" },
				filetypes = { "fish" },
			})

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = true,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
