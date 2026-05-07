local repo = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")

-- Must be set before lazy loads any plugin
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Isolate lazy data from main nvim install
local lazypath = repo .. "/.sandbox/lazy/lazy.nvim"
vim.env.LAZY = repo .. "/.sandbox/lazy"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	root = repo .. "/.sandbox/plugins",
	spec = {
		{
			dir = repo,
			name = "myconfig",
			lazy = false,
			priority = 1000,
			config = function()
				require("myconfig.common").setup()
				require("myconfig.personal").setup()
				-- require("myconfig.work").setup()
			end,
		},
		{ import = "myconfig.common.plugins" },
		{ import = "myconfig.personal.plugins" },
		-- { import = "myconfig.work.plugins" },
	},
	change_detection = { notify = false },
})
