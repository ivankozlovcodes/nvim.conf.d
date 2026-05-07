return {
	"shortcuts/no-neck-pain.nvim",
	lazy = false,
	keys = {
		{ "<leader>cn", "<cmd>NoNeckPain<cr>", desc = "Toggle centered layout" },
	},
	opts = {
		width = 100,
	},
	config = function(_, opts)
		require("no-neck-pain").setup(opts)
		-- built-in enableOnVimEnter crashes on Alpha's nil tab (no-neck-pain #467)
		local group = vim.api.nvim_create_augroup("NoNeckPainAutoEnable", { clear = true })

		local function try_enable()
			if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
				vim.api.nvim_del_augroup_by_name("NoNeckPainAutoEnable")
				vim.cmd("NoNeckPain")
			end
		end

		vim.api.nvim_create_autocmd("VimEnter", {
			group = group,
			once = true,
			callback = function() vim.schedule(try_enable) end,
		})

		vim.api.nvim_create_autocmd("BufEnter", {
			group = group,
			callback = try_enable,
		})
	end,
}
