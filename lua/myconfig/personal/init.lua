local M = {}

function M.setup()
  -- Fyler
  vim.keymap.set("n", "<leader>e", function()
    require("fyler").toggle({ kind = "float" })
  end, { desc = "Open Fyler View" })

  -- Close buffer, fall back to Alpha if last
  vim.keymap.set("n", "<leader>bq", function()
    if vim.bo.modified then
      vim.notify("Unsaved changes. Save first.", vim.log.levels.WARN)
      return
    end
    local buflisted = vim.fn.getbufinfo({ buflisted = 1 })
    vim.cmd("bdelete")
    if #buflisted <= 1 then
      vim.cmd("Alpha")
    end
  end, { desc = "Close buffer" })

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

  -- LSP keymaps
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("PersonalLsp", { clear = true }),
    callback = function(e)
      local bopts = { buffer = e.buf }
      vim.keymap.set("n", "<leader>lh", function() vim.lsp.buf.hover() end,          bopts)
      vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end,  bopts)
      vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end,    bopts)
      vim.keymap.set("i", "<C-h>",      function() vim.lsp.buf.signature_help() end, bopts)
    end,
  })
end

return M
