local M = {}

function M.setup()
	-- Load the unified VCS keymaps and logic
	local ok, vcs = pcall(require, "myconfig.experimental.vcs")
	if not ok then
		vim.notify("Failed to load experimental VCS config: " .. tostring(vcs), vim.log.levels.ERROR)
	end
end

return M
