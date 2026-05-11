return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	branch = "stable",
	lazy = false,
	keys = {
		{ "-", "<cmd>Fyler<cr>", desc = "Open Fyler" },
		{
			"<leader>fl",
			function()
				require("fyler").toggle({ dir = vim.fn.expand("%:p:h"), kind = "float" })
			end,
			desc = "Open Fyler View",
		},
		{
			"<leader>e",
			function()
				require("fyler").toggle({ kind = "float" })
			end,
			desc = "Open Fyler View",
		},
	},
	opts = {
		views = {
			finder = { default_explorer = true },
		},
		integrations = { icon = "nvim_web_devicons" },
		win = {
			width = 0.3,
			height = 0.8,
			relative = "editor",
			border = "rounded",
		},
	},
}
