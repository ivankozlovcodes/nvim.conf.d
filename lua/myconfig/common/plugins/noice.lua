return {
	{
		"rcarriga/nvim-notify",
		opts = {
			merge_duplicates = true,
			render = "minimal",
			timeout = 3000,
		},
		config = function(_, opts)
			local actual_stage = vim.g.neovide and "slide" or "static"
			local bg_color = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
			vim.tbl_deep_extend("force", opts, {
				stages = actual_stage,
				background_colour = bg_color and string.format("#%06x", bg_color) or "#000000",
			})
			require("notify").setup(opts)
			vim.notify = require("notify")
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				views = {
					cmdline_popup = {
						position = { row = 15, col = "50%" },
						size = { width = 60, height = "auto" },
					},
					popupmenu = {
						relative = "editor",
						position = { row = 8, col = "50%" },
						size = { width = 60, height = 10 },
						border = { style = "rounded", padding = { 0, 1 } },
						win_options = {
							winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
						},
					},
				},
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
					},
					signature = { enabled = true },
					messages = {
						enabled = true,
						view = "notify",
						view_error = "notify",
						view_warn = "notify",
						view_history = "split",
						view_search = "virtualtext",
					},
				},
				popupmenu = { enabled = true, backend = "nui" },
				cmdline = { enabled = true, view = "cmdline_popup" },
				notify = { enabled = true, view = "notify" },
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = false,
				},
			})
		end,
		keys = {
			{
				"<leader>tn",
				function()
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						if vim.bo[buf].filetype == "noice" then
							vim.api.nvim_win_close(win, false)
							return
						end
					end
					require("noice").cmd("history")
				end,
				desc = "Toggle notifications window",
			},
		},
	},
}
