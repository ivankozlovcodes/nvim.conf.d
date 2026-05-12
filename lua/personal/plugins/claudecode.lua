local toggle_key = "<C-,>"

return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	config = function(_, opts)
		require("claudecode").setup(opts)
		vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
			callback = function(ev)
				if vim.b[ev.buf].claudecode_diff_tab_name then
					vim.schedule(function()
						pcall(vim.cmd, "ClaudeCodeFocus")
					end)
				end
			end,
		})
	end,
	opts = {
		terminal = {
			---@module "snacks"
			---@type snacks.win.Config|{}
			snacks_win_opts = {
				position = "float",
				width = 0.9,
				height = 0.9,
				keys = {
					claude_hide = {
						toggle_key,
						function(self)
							self:hide()
						end,
						mode = "t",
						desc = "Hide",
					},
				},
				on_win = function(self)
					self:on("WinLeave", function()
						self:hide()
					end)
				end,
			},
		},
	},
	keys = {
		{ "<leader>a", nil, desc = "AI/Claude Code" },
		{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude", mode = { "n", "t" } },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude", mode = { "n", "t" } },
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
		{
			"<leader>as",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "fyler" },
		},
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		{ toggle_key, "<cmd>ClaudeCode<cr>", desc = "Claude Code", mode = { "n", "x" } },
	},
}
