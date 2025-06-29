vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if
        client
        and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
    then
      local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = function()
          vim.lsp.buf.document_highlight()
        end
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
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    end
  end,
})

vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(args)
    if args.data.params.value.kind == 'end' then
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      if client:supports_method("textDocument/foldingRange") then
        if args.data.method == 'textDocument/didOpen' then
          vim.lsp.foldclose('imports', vim.fn.bufwinid(args.buf))
        end
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"

        if client.config.name == 'vtsls' then
          vim.wo[win][0].foldtext = "v:lua.custom_foldtext('no end text')"
        end
      end
    end
  end,
})




vim.keymap.set("n", "grh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Inlay [H]ints" })


--  override the nvim-lspconfig rootmarkers
vim.lsp.config.denols = {
  workspace_required = true,
  root_markers = { "deno.json", "deno.jsonc" },
}
vim.lsp.config.angularls = {
  root_markers = { "angular.json" },
  workspace_required = true,
}
vim.lsp.config.hyprls = {
  root_markers = { "hyprland.conf" },
}

vim.lsp.config.lua_ls = {
  settings = {
    Lua = {
      hint = {
        enable = true,
        semicolon = "All",
        setType = true,
      },
    },
  },
}

vim.lsp.config.vtsls = {
  workspace_required = true,
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      codelens = {
        enable = true,
      },
    },
  }
}

vim.lsp.enable({
  "angularls",
  "bashls",
  "cssls",
  "denols",
  "emmet_language_server",
  "fish_lsp",
  "hyprls",
  "lua_ls",
  "marksman",
  "ruff",
  "stylelint_lsp",
  "tailwindcss",
  "vtsls",
})
