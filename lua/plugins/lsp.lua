return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local util = require("lspconfig.util")

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "gopls", "clangd" },
			})

			-- Clean server list
			local servers = {
				lua_ls = {
					root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
				},
				gopls = {},
				clangd = {},
			}

			for server, config in pairs(servers) do
				config.capabilities = capabilities
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end

			-- UI/Diagnostic cleanup
			vim.diagnostic.config({
				float = { border = "rounded" },
				severity_sort = true,
				signs = false,
				virtual_text = { prefix = "●" },
			})
		end,
	},
}
