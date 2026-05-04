return {
    "nvim-focus/focus.nvim",
    opts = {
        enable = true,
        -- Exclude nvim-tree from auto-resizing
        ui = {
            excluded_filetypes = { "NvimTree" },
        },
        -- Alternatively/Additionally, exclude it from the resizing logic
        autoresize = {
            enable = true,
        },
    },
    config = function(_, opts)
        require("focus").setup(opts)
        
        -- Force focus to ignore nvim-tree via an autocmd if the table above isn't enough
        local group = vim.api.nvim_create_augroup("FocusIgnore", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = "NvimTree",
            callback = function()
                vim.b.focus_disable = true
            end,
        })
    end
}
