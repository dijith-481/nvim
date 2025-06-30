local function keymap(kb, fn, desc, args)
  return vim.keymap.set("n", kb, function()
    local parts = vim.split(fn, "%.")
    local obj = Snacks
    for _, part in ipairs(parts) do
      obj = obj[part]
    end
    obj(args)
  end, { desc = desc })
end
return {
  -- keymap("<leader>dm", "dim", "[D]i[M]"),
  -- keymap("<leader>dn", "dim.disable", "[D]i[M]"),
  vim.keymap.set('n', '<leader>dm', function()
    local ok, Snacks = pcall(require, 'snacks')
    if not ok then
      return
    end

    if Snacks.dim.enabled then
      Snacks.dim.disable()
    else
      Snacks.dim()
    end
  end, {
    noremap = true,
    silent = true,
    desc = "[D]i[M]"
  }),
  keymap("<leader>tr", "terminal", "Toggle Terminal"),
  keymap("<leader>.", "scratch", "Toggle Scratch Buffer"),
  keymap("<leader>S", "scratch.select", "Select Scratch Buffer"),
  keymap("<leader>z", "zen", "Toggle [Z]en mode"),
  keymap("<leader>lg", "lazygit", "lazy git"),
  keymap("<leader>e", "explorer", "File [E]xplorer"),

  keymap("<leader><leader>", "picker.smart", "Smart Find Files"),
  keymap("<leader>,", "picker.buffers", "Buffers"),
  keymap("<leader>/", "picker.grep", "Grep"),
  keymap("<leader>:", "picker.command_history", "Command History"),
  keymap("gn", "picker.notifications", "Notification History"),

  keymap("<leader>fb", "picker.buffers", " Find [B]uffers"),
  keymap("<leader>ff", "picker.files", "Find [F]iles"),
  keymap("<leader>fg", "picker.git_files", "Find [G]it Files"),
  keymap("<leader>fp", "picker.projects", "Find [P]rojects"),
  keymap("<leader>fr", "picker.recent", "Find [R]ecent"),

  keymap("<leader>gB", "gitbrowse", "Git [B]rowse"),
  keymap("<leader>gb", "picker.git_branches", "Git [B]ranches"),
  keymap("<leader>gl", "picker.git_log", "Git [L]og"),
  keymap("<leader>gL", "picker.git_log_line", "Git Log [L]ine"),
  keymap("<leader>gs", "picker.git_status", "Git [S]tatus"),
  keymap("<leader>gS", "picker.git_stash", "Git [S]tash"),
  keymap("<leader>gd", "picker.git_diff", "Git [D]iff (Hunks)"),
  keymap("<leader>gf", "picker.git_log_file", "Git Log [F]ile"),

  keymap("<leader>sb", "picker.lines", "[B]uffer Lines"),
  keymap("<leader>sB", "picker.grep_buffers", "Grep Open [B]uffers"),
  keymap("<leader>sg", "picker.grep", "[G]rep"),
  keymap("<leader>sw", "picker.grep_word", "Grep [W]ord"),
  keymap('<leader>s"', "picker.registers", '["]Registers'),
  keymap("<leader>s/", "picker.search_history", "[/]Search History"),
  keymap("<leader>sa", "picker.autocmds", "[A]utocmds"),
  keymap("<leader>sb", "picker.lines", "[B]uffer Lines"),
  keymap("<leader>sc", "picker.command_history", "[C]ommand History"),
  keymap("<leader>sC", "picker.commands", "[C]ommands"),
  keymap("<leader>sd", "picker.diagnostics", "[D]iagnostics"),
  keymap("<leader>sD", "picker.diagnostics_buffer", "Buffer [D]iagnostics"),
  keymap("<leader>sh", "picker.help", "[H]elp Pages"),
  keymap("<leader>sH", "picker.highlights", "[H]ighlights"),
  keymap("<leader>si", "picker.icons", "[I]cons"),
  keymap("<leader>sj", "picker.jumps", "[J]umps"),
  keymap("<leader>sk", "picker.keymaps", "[K]eymaps"),
  keymap("<leader>sl", "picker.loclist", "[L]ocation List"),
  keymap("<leader>sm", "picker.marks", "[M]arks"),
  keymap("<leader>sM", "picker.man", "[M]an Pages"),
  keymap("<leader>sp", "picker.lazy", "[P]lugin Spec"),
  keymap("<leader>sq", "picker.qflist", "[Q]uickfix List"),
  keymap("<leader>sR", "picker.resume", "[R]esume"),
  keymap("<leader>su", "picker.undo", "[U]ndo History"),
  keymap("<leader>sz", "picker.zoxide", "[Z]oxide"),
  keymap("<leader>uC", "picker.colorschemes", "[C]olorschemes"),
  keymap("sL", "picker.lsp_config", "Search [L]SP [C]onfig"),

  keymap("gd", "picker.lsp_definitions", "Goto [D]efinition"),
  keymap("gD", "picker.lsp_declarations", "Goto [D]eclaration"),
  keymap("grD", "picker.lsp_declarations", "Goto [D]eclaration"),
  keymap("grd", "picker.lsp_definitions", "Goto [D]efinition"),
  keymap("grr", "picker.lsp_references", "[R]eferences"),
  keymap("gri", "picker.lsp_implementations", "Goto [I]mplementation"),
  keymap("grt", "picker.lsp_type_definitions", "Goto T[y]pe Definition"),
  keymap("gO", "picker.lsp_symbols", "LSP [S]ymbols"),
  keymap("gW", "picker.lsp_workspace_symbols", "LSP Workspace [S]ymbols"),

  vim.keymap.set(
    "n",
    "<leader>fc",
    "<cmd> lua Snacks.picker.pick({source='files',cwd=vim.fn.stdpath('config'),...})<CR>",
    { desc = "Find Nvim [C]onfig " }
  ),
  vim.keymap.set(
    "n",
    "<leader>fh",
    "<cmd> lua Snacks.picker.pick({source='files',cwd=vim.fn.expand('$HOME/.config/hypr'),...})<CR>",
    { desc = "Find Hyprland [C]onfig " }
  ),
  vim.keymap.set(
    "n",
    "<leader>fn",
    "<cmd> lua Snacks.picker.pick({source='files',cwd=vim.fn.expand('$HOME/.config/niri'),...})<CR>",
    { desc = "Find Hyprland [C]onfig " }
  )
}
