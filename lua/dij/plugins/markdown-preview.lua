local function build_preview(params)
  vim.notify("Building markdown preview", vim.log.levels.INFO)
  local obj = vim.system({ "npm", "install" }, { cwd = params.path .. "/app" }):wait()
  if obj.code == 0 then
    vim.notify("Building markdown preview done", vim.log.levels.INFO)
  else
    vim.notify("Building markdown preview failed", vim.log.levels.ERROR)
  end
end

Add({
  source = "iamcco/markdown-preview.nvim",
  hooks = {
    post_checkout = build_preview,
    post_install = build_preview,
  },
})

-- vim.api.nvim_create_autocmd({ "FileType" }, {

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("markdownpreview", { clear = true }),
  pattern = { "*.md" },
  callback = function()
    vim.g.mkdp_filetypes = { "markdown" }
    -- delay  to load the command
    vim.defer_fn(function()
      vim.cmd("MarkdownPreviewToggle")
    end, 100)
  end,
})
