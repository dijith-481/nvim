return {
	{	"lewis6991/gitsigns.nvim",
	config = function()
 require('gitsigns').setup{



numhl = true,
    sign_priority = 15,

 }

 vim.keymap.set("n","<leader>hp",":Gitsigns preview_hunk<CR>",{})
	end
},
-- nvim v0.8.0
 {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
   -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>lg", ":LazyGit<CR>", desc = "LazyGit" }
    }
}
}
