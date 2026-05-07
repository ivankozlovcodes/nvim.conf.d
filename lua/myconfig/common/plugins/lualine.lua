return {
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = { lsp = { auto_attach = false } },
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "SmiteshP/nvim-navic",
    },
    opts = {
      options = {
        theme = "catppuccin",
        globalstatus = true,
        disabled_filetypes = {
          winbar = { "alpha", "no-neck-pain" },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      winbar = {
        lualine_c = {
          { "filename" },
          {
            function() return require("nvim-navic").get_location() end,
            cond = function() return require("nvim-navic").is_available() end,
          },
        },
      },
      inactive_winbar = {
        lualine_c = { { "filename" } },
      },
    },
  },
}
