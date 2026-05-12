return {
	"linguini1/pulse.nvim",
	opts = {},
	version = "*",
	keys = {
		{
			"<leader>pt",
			function()
				require("pulse").pick_timers()
			end,
			desc = "Pulse: list/toggle timers",
		},
		{
			"<leader>pa",
			function()
				vim.ui.input({ prompt = "Timer name: " }, function(name)
					if not name or name == "" then
						return
					end
					vim.ui.input({ prompt = "Interval (minutes): " }, function(interval)
						if not interval or interval == "" then
							return
						end
						vim.ui.input({ prompt = "Message: " }, function(message)
							if not message or message == "" then
								return
							end
							require("pulse").add(name, {
								interval = tonumber(interval),
								message = message,
								enabled = true,
								one_shot = true,
							})
						end)
					end)
				end)
			end,
			desc = "Pulse: add timer",
		},
		{
			"<leader>pd",
			function()
				vim.ui.input({ prompt = "Timer name to remove: " }, function(name)
					if not name or name == "" then
						return
					end
					require("pulse").remove(name)
				end)
			end,
			desc = "Pulse: remove timer",
		},
	},
	config = function()
		require("pulse").setup()
	end,
}
