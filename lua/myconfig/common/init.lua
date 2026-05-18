local M = {}

-- Repo root: used by keymaps to open config files regardless of where lazy installed it
vim.g.myconfig_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h:h")

function M.setup()
	if vim.fn.has("unix") == 1 and vim.env.WAYLAND_DISPLAY then
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
	end

	-- Options
	vim.opt.number = true

	vim.opt.tabstop = 2
	vim.opt.softtabstop = 2
	vim.opt.shiftwidth = 2
	vim.opt.expandtab = true

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
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.opt.foldtext = ""
	vim.opt.foldlevel = 99

	vim.opt.updatetime = 300
	vim.opt.cmdheight = 0
	vim.opt.laststatus = 3

	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.clipboard = "unnamedplus"

	-- Keymaps: generic editing
	local opts = { noremap = true, silent = true }

	vim.keymap.set({ "n", "i", "v" }, "<F1>", "<nop>", { desc = "Disable F1 Help" })
	vim.keymap.set("n", "q:", "<nop>", { desc = "Disable command-line window" })

	-- Window navigation
	vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
	vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
	vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
	vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })

	-- Replace word under cursor with yanked
	vim.keymap.set("n", "<leader>r", "ciw<C-r>0<ESC>")
	vim.keymap.set("v", "<leader>r", "c<C-r>0<ESC>")

	-- Indenting
	vim.keymap.set("v", "<", "<gv", opts)
	vim.keymap.set("v", ">", ">gv", opts)

	-- Search
	vim.keymap.set("n", "<Esc>", "<Esc>:noh<cr>", opts)
	vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
	-- Highlight then <leader>r to replace all occurrences in file
	vim.keymap.set("v", "<leader>r", [["hy:%s/<C-r>h//gc<left><left><left>]])
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

	-- Tab navigation
	vim.keymap.set("n", "<C-t>h", "<cmd>tabprevious<cr>", { desc = "Prev Tab" })
	vim.keymap.set("n", "<C-t>l", "<cmd>tabnext<cr>", { desc = "Next Tab" })
	vim.keymap.set("n", "<C-t>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
	vim.keymap.set("n", "<C-t>c", "<cmd>tabclose<cr>", { desc = "Close Tab" })

	-- Window resize
	vim.keymap.set("n", "<A-h>", "<cmd>vertical resize -2<cr>")
	vim.keymap.set("n", "<A-l>", "<cmd>vertical resize +2<cr>")

	-- Colorcolumn toggle
	vim.keymap.set("n", "<leader>tc", function()
		local current = vim.opt.colorcolumn:get()
		if vim.tbl_contains(current, "80") then
			vim.opt.colorcolumn = ""
		else
			vim.opt.colorcolumn = "80"
		end
	end, { desc = "Toggle colorcolumn" })

	-- Toggle warnings only
	local warnings_on = true
	vim.keymap.set('n', '<leader>tW', function()
		warnings_on = not warnings_on
		vim.diagnostic.config({
			underline = { severity = { min = warnings_on and vim.diagnostic.severity.WARN or vim.diagnostic.severity.ERROR } },
			virtual_text = { severity = { min = warnings_on and vim.diagnostic.severity.WARN or vim.diagnostic.severity.ERROR } },
			signs = { severity = { min = warnings_on and vim.diagnostic.severity.WARN or vim.diagnostic.severity.ERROR } },
		})
		vim.notify("Warnings " .. (warnings_on and "on" or "off"))
	end, { desc = "Toggle warnings only" })

	-- Save-all quit
	vim.keymap.set("n", "<leader>qa", "<cmd>xa<cr>", { desc = "Save all and quit" })

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

	vim.keymap.set("n", "<leader>lj", function()
		goto_error_then_hint(1)
	end, { desc = "Next diagnostic" })
	vim.keymap.set("n", "<leader>lk", function()
		goto_error_then_hint(-1)
	end, { desc = "Prev diagnostic" })

	-- Buffer management
	vim.keymap.set("n", "<leader>bq", function()
		if vim.bo.modified then
			vim.notify("Unsaved changes. Save first.", vim.log.levels.WARN)
			return
		end
		vim.cmd("bdelete")
	end, { desc = "Close buffer" })
	vim.keymap.set("n", "<leader>bl", "<cmd>edit#<cr>", { desc = "Last buffer" })
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

	-- Warn on non-ASCII keypress in normal mode (wrong keyboard layout)
	local last_layout_warn = 0
	vim.on_key(function(key)
		if vim.fn.mode() ~= "n" then
			return
		end
		local b = string.byte(key, 1)
		if not b or b == 27 then
			return
		end
		if b >= 0xC2 and #key >= 2 then
			local now = vim.uv.now()
			if now - last_layout_warn > 200 then
				last_layout_warn = now
				vim.notify("Wrong keyboard layout", vim.log.levels.WARN)
			end
		end
	end)

	-- Autocmds
	local augroup = vim.api.nvim_create_augroup
	local autocmd = vim.api.nvim_create_autocmd
	local conform_group = augroup("ConformFormat", { clear = true })
	local yank_group = augroup("HighlightYank", { clear = true })

	autocmd("BufWritePre", {
		group = conform_group,
		callback = function(args)
			require("conform").format({
				bufnr = args.buf,
				lsp_fallback = true,
				stop_after_first = false,
			})
		end,
	})

	autocmd("LspAttach", {
		group = augroup("CommonLsp", { clear = true }),
		callback = function(e)
			local bopts = { buffer = e.buf }
			vim.keymap.set("n", "<leader>lh", function()
				vim.lsp.buf.hover()
			end, bopts)
			vim.keymap.set("n", "<leader>le", function()
				vim.diagnostic.open_float()
			end, bopts)
			vim.keymap.set("n", "<leader>la", function()
				vim.lsp.buf.code_action()
			end, bopts)
			vim.keymap.set("i", "<C-h>", function()
				vim.lsp.buf.signature_help()
			end, bopts)
			vim.keymap.set("n", "<leader>ln", "]m", { buffer = e.buf, remap = true, desc = "Next symbol/method" })
			vim.keymap.set("n", "<leader>lb", "[m", { buffer = e.buf, remap = true, desc = "Prev symbol/method" })

			local client = vim.lsp.get_client_by_id(e.data.client_id)
			if client and client.server_capabilities.documentSymbolProvider then
				require("nvim-navic").attach(client, e.buf)
			end
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
end

return M
