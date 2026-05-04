-- Disable F1 help globally
vim.keymap.set({ "n", "i", "v" }, "<F1>", "<nop>", { desc = "Disable F1 Help" })

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Tab Navigation
vim.keymap.set("n", "<C-t>h", "<cmd>tabprevious<cr>", { desc = "Prev Tab" })
vim.keymap.set("n", "<C-t>l", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<C-t>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<C-t>c", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- resize
vim.keymap.set("n", "<A-h>", "<cmd>vertical resize -2<cr>")
vim.keymap.set("n", "<A-l>", "<cmd>vertical resize +2<cr>")

-- potato hands
vim.keymap.set("n", "<leader>qq", "<cmd>xa<cr>", { desc = "Save all and quit" })

-- Close all editor windows in the current tab, but keep NvimTree
vim.keymap.set("n", "<leader>tc", function()
	local current_tab = vim.api.nvim_get_current_tabpage()
	local wins = vim.api.nvim_tabpage_list_wins(current_tab)

	for _, win in ipairs(wins) do
		local buf = vim.api.nvim_win_get_buf(win)
		local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

		-- Close the window if it's NOT nvim-tree
		if ft ~= "NvimTree" then
			-- If it's the last window (besides nvim-tree), we can't 'close' it
			-- without closing the tab, so we just check count
			if #vim.api.nvim_tabpage_list_wins(current_tab) > 1 then
				vim.api.nvim_win_close(win, false)
			end
		end
	end
end, { desc = "Close all editors in current tab" })

-- fyler
vim.keymap.set("n", "<leader>e", function()
	require("fyler").toggle({ kind = "float" })
end, { desc = "Open Fyler View" })

vim.keymap.set("n", "<leader>q", function()
	-- Block if file unsaved
	if vim.bo.modified then
		vim.notify("Unsaved changes. Save first.", vim.log.levels.WARN)
		return
	end

	local buflisted = vim.fn.getbufinfo({ buflisted = 1 })

	-- Safe to delete
	vim.cmd("bdelete")

	-- Launch Alpha if last file
	if #buflisted <= 1 then
		vim.cmd("Alpha")
	end
end, { desc = "Close saved file or open Alpha" })

-- Helper: check all listed buffers for changes
local function any_unsaved()
	for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if buf.changed == 1 then
			-- Check if buffer nameless and textless
			local no_name = buf.name == ""
			local lines = vim.api.nvim_buf_get_lines(buf.bufnr, 0, 1, false)
			local no_text = buf.linecount <= 1 and (lines[1] == "" or lines[1] == nil)

			-- Block quit UNLESS buffer is useless ghost
			if not (no_name and no_text) then
				return true
			end
		end
	end
	return false
end

-- qq: Wipe all -> Alpha (Block if unsaved)
vim.keymap.set("n", "qq", function()
	if any_unsaved() then
		vim.notify("Unsaved changes. Save first.", vim.log.levels.WARN)
		return
	end
	vim.cmd("silent! %bdelete")
	vim.cmd("Alpha")
end, { desc = "Close all, fallback to Alpha" })
