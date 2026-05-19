return {
	"nvim-focus/focus.nvim",
	opts = {
		autoresize = { enable = true },
		enable = true,
		ui = { excluded_filetypes = { "NvimTree", "no-neck-pain", "DiffviewFiles", "DiffviewFileHistory" } },
	},
	config = function(_, opts)
		require("focus").setup(opts)
		local group = vim.api.nvim_create_augroup("FocusIgnore", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = { "NvimTree", "no-neck-pain", "DiffviewFiles", "DiffviewFileHistory" },
			callback = function()
				vim.b.focus_disable = true
			end,
		})
	end,
}
