return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    { "<leader>lx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)" },
    { "<leader>lX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer diagnostics (Trouble)" },
  },
  opts = {},
}
