return {
  "shortcuts/no-neck-pain.nvim",
  keys = {
    { "<leader>cn", "<cmd>NoNeckPain<cr>", desc = "Toggle centered layout" },
  },
  opts = {
    width = 100,
    buffers = {
      right = {
        -- Compensate for line numbers + signcolumn on left (~6 cols)
        width = 6,
      },
    },
  },
}
