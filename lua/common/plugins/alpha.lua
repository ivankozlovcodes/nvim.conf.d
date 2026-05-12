return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "amansingh-afk/milli.nvim" },
	lazy = false,
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local milli = require("milli")

		local splash = milli.load({ splash = "blackhole" })
		dashboard.section.header.val = splash.frames[1]

		dashboard.section.buttons.val = {
			dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "󰈞  Find file", ":Fyler<CR>"),
			dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
		}

		alpha.setup(dashboard.opts)
		milli.alpha({ splash = "blackhole", loop = true })
	end,
}
