return {
	"shortcuts/no-neck-pain.nvim",
	keys = {
		{ "<leader>cn", "<cmd>NoNeckPain<cr>", desc = "Toggle centered layout" },
	},
	opts = {
		width = 100,
	},
	config = function(_, opts)
		require("no-neck-pain").setup(opts)
		vim.api.nvim_create_autocmd("BufReadPost", {
			once = true,
			callback = function()
				if vim.bo.buftype == "" then
					vim.cmd("NoNeckPain")
				end
			end,
		})
	end,
}
