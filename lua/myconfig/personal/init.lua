local M = {}

function M.setup()
  -- Fyler
  vim.keymap.set("n", "<leader>e", function()
    require("fyler").toggle({ kind = "float" })
  end, { desc = "Open Fyler View" })


  -- Wipe all buffers → Alpha (block if unsaved)
  local function any_unsaved()
    for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
      if buf.changed == 1 then
        local no_name = buf.name == ""
        local lines = vim.api.nvim_buf_get_lines(buf.bufnr, 0, 1, false)
        local no_text = buf.linecount <= 1 and (lines[1] == "" or lines[1] == nil)
        if not (no_name and no_text) then
          return true
        end
      end
    end
    return false
  end

  vim.keymap.set("n", "<leader>qa", function()
    if any_unsaved() then
      vim.notify("Unsaved changes. Save first.", vim.log.levels.WARN)
      return
    end
    vim.cmd("silent! %bdelete")
    vim.cmd("Alpha")
  end, { desc = "Close all, fallback to Alpha" })

  -- Alpha fallback: open Alpha when last buffer is empty
  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("AlphaFallback", { clear = true }),
    callback = function()
      local win_config = vim.api.nvim_win_get_config(0)
      if win_config.relative ~= "" then return end
      if vim.bo.buftype ~= "" then return end

      local bufs = vim.fn.getbufinfo({ buflisted = 1 })
      local name = vim.api.nvim_buf_get_name(0)
      local ft = vim.bo.filetype

      if #bufs <= 1 and name == "" and ft == "" then
        vim.cmd("Alpha")
      end
    end,
    desc = "Launch Alpha on empty buffer",
  })

end

return M
