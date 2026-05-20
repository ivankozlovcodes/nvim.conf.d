return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"hrsh7th/nvim-cmp",
	},
	keys = {
		{ "<leader>nn", "<cmd>ObsidianNew<cr>", desc = "New Obsidian Note" },
		{ "<leader>ns", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian Notes" },
		{ "<leader>nb", "<cmd>ObsidianBacklinks<cr>", desc = "Show Obsidian Backlinks" },
	},
	opts = {
		workspaces = {
			{
				name = "notes",
				path = "~/notes",
			},
		},
		-- Full-featured configuration
		daily_notes = {
			folder = "journal/daily",
			date_format = "%Y-%m-%d",
			alias_format = "%B %d, %Y",
			default_tags = { "daily-notes" },
		},
		templates = {
			folder = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},
		ui = {
			enable = true,
			update_debounce = 200,
			checkboxes = {
				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
				["x"] = { char = "", hl_group = "ObsidianDone" },
			},
		},

		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},

		-- Smart link navigation
		mappings = {
			-- Overrides "gf" to follow smart Obsidian links inside visual/normal mode
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { keepalt = true, buffer = true, expr = true },
			},
			-- Toggle check-boxes
			["<leader>nc"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
		},
	},
}
