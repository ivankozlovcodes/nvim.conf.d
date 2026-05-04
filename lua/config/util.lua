local M = {}

M.source_folder = function(folder)
	-- Normalize path: remove 'lua/' if the user accidentally included it
	local clean_folder = folder:gsub("^lua/", ""):gsub("^/", "")

	-- Find actual .lua files on disk
	local path = vim.fn.stdpath("config") .. "/lua/" .. clean_folder
	local files = vim.fn.glob(path .. "/*.lua", true, true)

	print(path)

	for _, file in ipairs(files) do
		print(file)
		-- Convert absolute path back to a module name relative to 'lua/' root
		-- Example: /home/user/.config/nvim/lua/myscripts/test.lua -> myscripts.test
		local module = file:match("lua/(.*)%.lua$"):gsub("/", ".")
		print(module)
		if module then
			require(module)
		end
	end
end

return M
