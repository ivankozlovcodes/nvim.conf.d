return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- 1. Setup and Install
      require("nvim-treesitter").setup()
      local ensure_installed = { "lua", "vim", "vimdoc", "javascript", "markdown", "markdown_inline" }
      require("nvim-treesitter").install(ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "oil", "NvimTree" },
        callback = function(args)
          vim.treesitter.stop(args.buf)
        end,
      })
    end,
  },

  -- Sticky Headers (Context)
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    config = function()
      require("treesitter-context").setup({
        enable = true,
        max_lines = 3, -- How many lines of sticky header to show
        trim_scope = "outer", -- Clean look for nested functions
      })
    end,
  },

  -- Markdown Rendering (Pretty tables, checkboxes, headers)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("render-markdown").setup({
        -- Optional: Disable concealment if you want to see the raw markdown symbols always
        -- anti_conceal = { enabled = true },
      })
    end,
  },

  -- Textobjects (af, if, etc.)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = false, -- Load immediately so mappings work
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- Add jumps to the jumplist (use Ctrl-o to go back)
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
        },
      })
    end,
  },
}
