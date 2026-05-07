local M = {}

function M.setup()
	-- Globals
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

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

	-- Options
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

	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.clipboard = "unnamedplus"

	-- Keymaps: generic editing
	local opts = { noremap = true, silent = true }

	vim.keymap.set({ "n", "i", "v" }, "<F1>", "<nop>", { desc = "Disable F1 Help" })
	vim.keymap.set("n", "<leader><leader>", function()
		vim.cmd("so")
	end)
	vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

	-- Clipboard
	vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', opts)
	vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', opts)

	-- Replace word under cursor with yanked
	vim.keymap.set("n", "<leader>r", "ciw<C-r>0<ESC>")
	vim.keymap.set("v", "<leader>r", "c<C-r>0<ESC>")

	-- Indenting
	vim.keymap.set("v", "<", "<gv", opts)
	vim.keymap.set("v", ">", ">gv", opts)

	-- Search
	vim.keymap.set("n", "<Esc>", "<Esc>:noh<cr>", opts)
	vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
	vim.keymap.set("x", "z/", "<C-\\><C-n>`</\\%V", { desc = "Search forward within visual selection" })
	vim.keymap.set("x", "z?", "<C-\\><C-n>`>?\\%V", { desc = "Search backward within visual selection" })

	-- Paste without clobbering register
	vim.keymap.set("v", "p", '"_dP', opts)

	-- Move selection
	vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
	vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

	-- Join without cursor jump
	vim.keymap.set("n", "J", "mzJ`z")

	-- Scroll centered
	vim.keymap.set("n", "<C-d>", "<C-d>zz")
	vim.keymap.set("n", "<C-u>", "<C-u>zz")

	-- Window ops via s
	vim.keymap.set("n", "s", "<C-w>", { desc = "Window operations" })

	-- Tab navigation
	vim.keymap.set("n", "<C-t>h", "<cmd>tabprevious<cr>", { desc = "Prev Tab" })
	vim.keymap.set("n", "<C-t>l", "<cmd>tabnext<cr>", { desc = "Next Tab" })
	vim.keymap.set("n", "<C-t>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
	vim.keymap.set("n", "<C-t>c", "<cmd>tabclose<cr>", { desc = "Close Tab" })

	-- Window resize
	vim.keymap.set("n", "<A-h>", "<cmd>vertical resize -2<cr>")
	vim.keymap.set("n", "<A-l>", "<cmd>vertical resize +2<cr>")

	-- Save-all quit
	vim.keymap.set("n", "<leader>qq", "<cmd>xa<cr>", { desc = "Save all and quit" })

	-- Colorcolumn toggle
	vim.keymap.set("n", "<leader>cc", function()
		local current = vim.opt.colorcolumn:get()
		if vim.tbl_contains(current, "80") then
			vim.opt.colorcolumn = ""
		else
			vim.opt.colorcolumn = "80"
		end
	end, { desc = "Toggle colorcolumn=80" })

	-- Copy file path
	vim.keymap.set("n", "<C-g>", function()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "n", false)
		local path = vim.fn.expand("%:.")
		if path == "" then
			vim.notify("[No file]", vim.log.levels.WARN)
			return
		end
		vim.fn.setreg("+", path)
		vim.fn.setreg('"', path)
	end, { desc = "Show file info and copy file path" })

	-- Terminal escape
	vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")

	-- Diagnostics
	local pos_equal = function(p1, p2)
		local r1, c1 = unpack(p1)
		local r2, c2 = unpack(p2)
		return r1 == r2 and c1 == c2
	end

	local goto_error_then_hint = function(count)
		local pos = vim.api.nvim_win_get_cursor(0)
		vim.diagnostic.jump({ count = count, severity = vim.diagnostic.severity.ERROR, wrap = true })
		local pos2 = vim.api.nvim_win_get_cursor(0)
		if pos_equal(pos, pos2) then
			vim.diagnostic.jump({ count = count, wrap = true })
		end
	end

	vim.keymap.set("n", "<leader>gj", function()
		goto_error_then_hint(1)
	end)
	vim.keymap.set("n", "<leader>gk", function()
		goto_error_then_hint(-1)
	end)

	-- Quickfix
	vim.keymap.set("n", "<leader>qfc", function()
		vim.fn.setqflist({})
	end, { desc = "Clear quickfix" })
	vim.keymap.set("n", "<leader>qfe", function()
		vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
	end, { desc = "Send errors to quickfix" })
	vim.keymap.set("n", "<leader>qfw", function()
		vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.WARN })
	end, { desc = "Send warnings to quickfix" })
	vim.keymap.set("n", "<leader>qfh", function()
		vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.HINT })
	end, { desc = "Send hints to quickfix" })
	vim.keymap.set("n", "<leader>qc", "<cmd>:cclose<cr>", { desc = "Close quickfix" })
	vim.keymap.set("n", "<leader>qo", "<cmd>:copen<cr>", { desc = "Open quickfix" })

	-- Buffer management
	vim.keymap.set("n", "<leader>bb", "<cmd>edit#<cr>", { desc = "Last buffer" })
	vim.keymap.set("n", "<leader>bd", function()
		local current = vim.fn.bufnr()
		local closed = 0
		for _, bufnr in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
			if bufnr.bufnr ~= current then
				vim.cmd("bdelete! " .. bufnr.bufnr)
				closed = closed + 1
			end
		end
		vim.notify("Closed " .. closed .. " buffer(s)")
	end, { desc = "Close all buffers except current" })

	-- Autocmds
	local augroup = vim.api.nvim_create_augroup
	local autocmd = vim.api.nvim_create_autocmd
	local TheJohnnyGroup = augroup("TheJohnny", {})
	local yank_group = augroup("HighlightYank", { clear = true })

	autocmd("BufWritePre", {
		callback = function(args)
			require("conform").format({
				bufnr = args.buf,
				lsp_fallback = true,
				stop_after_first = false,
			})
		end,
	})

	autocmd("TextYankPost", {
		desc = "Highlight when yanking text",
		group = yank_group,
		pattern = "*",
		callback = function()
			vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
		end,
	})

	autocmd("BufWritePre", {
		group = TheJohnnyGroup,
		pattern = "*",
		desc = "Remove trailing whitespace",
		command = [[%s/\s\+$//e]],
	})

	autocmd("LspAttach", {
		group = TheJohnnyGroup,
		callback = function(e)
			local bopts = { buffer = e.buf }
			vim.keymap.set("n", "<leader>d", function()
				hoverAndDiagnosticWindow()
			end, vim.tbl_deep_extend("keep", bopts, { noremap = false, silent = true }))
			vim.keymap.set("n", "<leader>vd", function()
				vim.diagnostic.open_float()
			end, bopts)
			vim.keymap.set("n", "<leader>ca", function()
				vim.lsp.buf.code_action()
			end, bopts)
			vim.keymap.set("i", "<C-h>", function()
				vim.lsp.buf.signature_help()
			end, bopts)
		end,
	})

	-- :Remember command
	vim.api.nvim_create_user_command("Remember", function(o)
		vim.cmd("filter /" .. o.args .. "/ map")
	end, { nargs = 1 })
end

return M
