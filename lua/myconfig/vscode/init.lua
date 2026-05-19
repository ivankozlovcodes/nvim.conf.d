local M = {}

function M.setup()
	-- VS Code Compatibility: Vertical split with Ctrl+\
	vim.keymap.set("n", "<C-\\>", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
	vim.keymap.set("i", "<C-\\>", "<Esc><cmd>vsplit<cr>", { desc = "Vertical Split" })
	vim.keymap.set("v", "<C-\\>", "<Esc><cmd>vsplit<cr>", { desc = "Vertical Split" })
end

return M
