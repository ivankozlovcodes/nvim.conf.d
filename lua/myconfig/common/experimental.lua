local M = {}

function M.setup()
	vim.opt.signcolumn = "yes"

	-- Center viewport, except for help pages
	local center_group = vim.api.nvim_create_augroup("center", { clear = true })
	vim.api.nvim_create_autocmd("BufEnter", {
		group = center_group,
		pattern = "*",
		callback = function()
			if vim.bo.filetype == "help" then
				vim.opt_local.scrolloff = 0
			else
				-- Setting to 99 centers the line
				vim.opt_local.scrolloff = 99
			end
		end,
	})
	vim.api.nvim_create_autocmd("FileType", {
		group = center_group,
		pattern = "help",
		callback = function()
			vim.api.nvim_create_autocmd("CursorMoved", {
				buffer = 0,
				command = "normal! zt",
			})
		end,
	})

	-- Resize windows when vim is resized to be equal in size
	vim.api.nvim_create_autocmd("VimResized", {
		group = vim.api.nvim_create_augroup("window_resize", { clear = true }),
		pattern = "*",
		command = "wincmd =",
	})

	-- Highlight cursor line when window is active
	local cursorline_group = vim.api.nvim_create_augroup("cursorline", { clear = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = cursorline_group,
		once = true,
		callback = function()
			vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "FocusGained" }, {
				pattern = "*",
				command = "setlocal cursorline",
				group = cursorline_group,
			})
			vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
				pattern = "*",
				command = "setlocal nocursorline",
				group = cursorline_group,
			})
		end,
	})

	-- Mappings
	local opts = { noremap = true, silent = true }

	-- Remap ; tp ; for faster command access
	vim.keymap.set({ "n", "v" }, ";", ":", { desc = "Command mode" })

	-- Move up and down by screen line, not file line
	vim.keymap.set({ "n", "v" }, "j", "gj", opts)
	vim.keymap.set({ "n", "v" }, "k", "gk", opts)

	-- Copy absolute path
	vim.keymap.set("n", "<leader>pa", '<cmd>let @+ = expand("%:p")<cr>', { desc = "Copy absolute path" })

	-- Warn on non-ASCII keypress in normal mode (wrong keyboard layout)
	local last_layout_warn = 0
	vim.on_key(function(key)
		if vim.fn.mode() ~= "n" then return end
		local b = string.byte(key, 1)
		if not b or b == 27 then return end
		if b >= 0xC2 and #key >= 2 then
			local now = vim.uv.now()
			if now - last_layout_warn > 200 then
				last_layout_warn = now
				vim.notify("Wrong keyboard layout", vim.log.levels.WARN)
			end
		end
	end)
end

return M
