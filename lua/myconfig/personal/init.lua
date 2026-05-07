local M = {}

function M.setup()
  -- Keymaps that depend on personal plugins (Alpha, Fyler, Rest, Jqit)

  -- Fyler
  vim.keymap.set("n", "<leader>e", function()
    require("fyler").toggle({ kind = "float" })
  end, { desc = "Open Fyler View" })

  -- Close tab windows except NvimTree
  vim.keymap.set("n", "<leader>tc", function()
    local current_tab = vim.api.nvim_get_current_tabpage()
    local wins = vim.api.nvim_tabpage_list_wins(current_tab)
    for _, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
      if ft ~= "NvimTree" then
        if #vim.api.nvim_tabpage_list_wins(current_tab) > 1 then
          vim.api.nvim_win_close(win, false)
        end
      end
    end
  end, { desc = "Close all editors in current tab" })

  -- Close buffer, fall back to Alpha if last
  vim.keymap.set("n", "<leader>q", function()
    if vim.bo.modified then
      vim.notify("Unsaved changes. Save first.", vim.log.levels.WARN)
      return
    end
    local buflisted = vim.fn.getbufinfo({ buflisted = 1 })
    vim.cmd("bdelete")
    if #buflisted <= 1 then
      vim.cmd("Alpha")
    end
  end, { desc = "Close saved file or open Alpha" })

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

  vim.keymap.set("n", "qq", function()
    if any_unsaved() then
      vim.notify("Unsaved changes. Save first.", vim.log.levels.WARN)
      return
    end
    vim.cmd("silent! %bdelete")
    vim.cmd("Alpha")
  end, { desc = "Close all, fallback to Alpha" })

  -- Rest / Jqit (tool-specific)
  vim.keymap.set("n", "<leader>xr", "<cmd>Rest run<cr>")
  vim.keymap.set("v", "<leader>jq", "<cmd>Jqit<cr>")

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
