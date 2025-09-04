Later(function()
	Add({ source = "stevearc/conform.nvim" })
	local conform = require("conform")
	conform.setup({
		formatters_by_ft = {
			c = { "clang-format" },
			cpp = { "clang-format" },
			fish = { "fish_indent" },
			bash = { "shfmt" },
			javascript = { "prettier" },
			tailwind = { "rustywind" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			svelte = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			lua = { "stylua" },
			dart = { "dart_format" },
			python = { "ruff_format" },
			java = { "google_java_format" },
			-- rust = { "dx_fmt", "rustfmt", lsp_format = "first" },
			kdl = { "kdlfmt" },
		},
		formatters = {},

		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 500, lsp_fallback = true }
		end,
	})

	vim.api.nvim_create_user_command("FormatDisable", function(args)
		if args.bang then
			vim.b.disable_autoformat = true
		else
			vim.g.disable_autoformat = true
		end
	end, {
		desc = "Disable autoformat-on-save",
		bang = true,
	})

	vim.keymap.set({ "n", "v" }, "<leader>bf", function()
		require("conform").format({ async = true, lsp_fallback = true })
	end, { desc = "[F]ormat" })
	vim.api.nvim_create_user_command("FormatEnable", function()
		vim.b.disable_autoformat = false
		vim.g.disable_autoformat = false
	end, {
		desc = "[B]uffer [F]ormat",
	})

	vim.keymap.set("n", "<leader>tf", function()
		if vim.b.disable_autoformat or vim.g.disable_autoformat then
			vim.cmd("FormatEnable")
		else
			vim.cmd("FormatDisable")
		end
	end, { desc = "[T]oggle [F]ormat" })
end)
