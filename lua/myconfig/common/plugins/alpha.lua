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

		-- Disable line numbers and empty line tildes on alpha buffer
		local alpha_group = vim.api.nvim_create_augroup("AlphaBufferFix", { clear = true })
		vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "BufWinEnter" }, {
			group = alpha_group,
			pattern = "*",
			callback = function()
				if vim.bo.filetype == "alpha" then
					vim.cmd("setlocal nonumber norelativenumber")
					vim.opt_local.fillchars:append({ eob = " " })
				end
			end,
		})

		-- Shield against delayed overrides (e.g., from late-loading plugins or configs)
		vim.api.nvim_create_autocmd("OptionSet", {
			group = alpha_group,
			pattern = { "number", "relativenumber" },
			callback = function()
				if vim.bo.filetype == "alpha" then
					vim.cmd("setlocal nonumber norelativenumber")
				end
			end,
		})

		alpha.setup(dashboard.opts)
		milli.alpha({ splash = "blackhole", loop = true })
	end,
}
