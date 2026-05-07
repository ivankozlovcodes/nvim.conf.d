return {
  "nvim-focus/focus.nvim",
  opts = {
    enable = true,
    ui = { excluded_filetypes = { "NvimTree", "no-neck-pain" } },
    autoresize = { enable = true },
  },
  config = function(_, opts)
    require("focus").setup(opts)
    local group = vim.api.nvim_create_augroup("FocusIgnore", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = { "NvimTree", "no-neck-pain" },
      callback = function()
        vim.b.focus_disable = true
      end,
    })
  end,
}
