return {
	"lewis6991/gitsigns.nvim",
	config = function()
 require('gitsigns').setup{



numhl = true,
    sign_priority = 15,

 }

 vim.keymap.set("n","<leader>gp",":Gitsigns preview_hunk<CR>",{})
	end
}
