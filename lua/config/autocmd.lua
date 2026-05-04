local augroup = vim.api.nvim_create_augroup
local TheJohnnyGroup = augroup("TheJohnny", {})

local autocmd = vim.api.nvim_create_autocmd
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
	desc = "Highlight when yanking (copying) text",
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd("BufWritePre", {
	group = TheJohnnyGroup,
	pattern = "*",
	desc = "Removes the trailing whitespaces",
	command = [[%s/\s\+$//e]],
})

autocmd("LspAttach", {
	group = TheJohnnyGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "<leader>d", function()
			hoverAndDiagnosticWindow()
		end, vim.tbl_deep_extend("keep", opts, { noremap = false, silent = true }))
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "<leader>ca", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("AlphaFallback", { clear = true }),
	callback = function()
		-- Ignore floating windows (like Fyler popups)
		local win_config = vim.api.nvim_win_get_config(0)
		if win_config.relative ~= "" then
			return
		end

		-- Ignore special plugin buffers (nofile, prompt, terminal)
		if vim.bo.buftype ~= "" then
			return
		end

		local bufs = vim.fn.getbufinfo({ buflisted = 1 })
		local name = vim.api.nvim_buf_get_name(0)
		local ft = vim.bo.filetype

		-- Check if last buffer is empty and nameless
		if #bufs <= 1 and name == "" and ft == "" then
			vim.cmd("Alpha")
		end
	end,
	desc = "Launch Alpha on empty buffer",
})
