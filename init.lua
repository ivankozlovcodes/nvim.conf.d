vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lwpath = vim.fn.stdpath("data") .. "/lazy/lazy-workspaces.nvim"
if not (vim.uv or vim.loop).fs_stat(lwpath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/ivankozlovcodes/lazy-workspaces.nvim.git",
		lwpath,
	})
end
vim.opt.rtp:prepend(lwpath)

require("lazy-workspaces").setup({
	configs = {
		default = {
			source = "https://github.com/ivankozlovcodes/nvim.conf.d",
			branch = "feat/lazy-workspaces",
		},
	},
	specs = { "plugins", "themes" },
	lazy = {
		dev = { path = "~/git", fallback = true },
		change_detection = { notify = false },
	},
})
