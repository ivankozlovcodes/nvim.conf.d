return {
	"shortcuts/no-neck-pain.nvim",
	keys = {
		{ "<leader>tN", "<cmd>NoNeckPain<cr>", desc = "Toggle centered layout" },
	},
	opts = {
		width = 100,
		disableOnLastBuffer = true,
		autocmds = {
			skipEnteringNoNeckPainBuffer = true,
		},
	},
}
