vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.textwidth = 80
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 16
vim.opt.isfname:append("@-@")

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99

vim.opt.updatetime = 20

vim.opt.cmdheight = 0
vim.opt.laststatus = 3

vim.g.clipboard = {
	name = "wl-clipboard",
	copy = {
		["+"] = { "wl-copy", "--trim-newline" },
		["*"] = { "wl-copy", "--trim-newline" },
	},
	paste = {
		["+"] = { "wl-paste", "--no-newline" },
		["*"] = { "wl-paste", "--no-newline" },
	},
	cache_enabled = 1,
}
vim.opt.clipboard = "unnamedplus"
