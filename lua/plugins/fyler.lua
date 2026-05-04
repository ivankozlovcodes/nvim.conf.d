return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	branch = "stable",
	lazy = false,
	keys = {
		{ "-", "<cmd>Fyler<cr>", desc = "Open Fyler" },
	},
	opts = {
		views = {
			finder = {
				default_explorer = true,
			},
		},
		integrations = {
			icon = "nvim_web_devicons",
		},
		win = {
			-- 0.0 to 1.0 for % of editor
			-- > 1 for fixed cells
			width = 0.3,
			height = 0.8,
			relative = "editor", -- "editor" | "win" | "cursor"
			border = "rounded", -- "none" | "single" | "double" | "rounded"
		},
	},
}
