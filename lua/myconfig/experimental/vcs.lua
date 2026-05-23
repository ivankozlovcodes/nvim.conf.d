local M = {}

-- VCS Core Detector
local function get_vcs_type()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" or vim.fn.isdirectory(dir) == 0 then
    dir = vim.fn.getcwd()
  end

  -- Scan upward for VCS markers
  local root = vim.fs.find({ ".git", ".hg", ".jj", ".citc" }, { upward = true, path = dir })[1]
  if not root then
    return nil
  end

  local marker = vim.fn.fnamemodify(root, ":t")
  if marker == ".git" then
    return "git"
  end
  if marker == ".hg" then
    return "hg"
  end
  if marker == ".jj" then
    return "jj"
  end
  if marker == ".citc" then
    return "p4"
  end
  return nil
end

-- Define Unified VCS Keymaps
function M.setup()
  -- 1. Unified VCS Status Panel (<leader>gg)
  vim.keymap.set("n", "<leader>gg", function()
    local vcs = get_vcs_type()
    if vcs == "git" then
      -- If folke/snacks.nvim is installed, use lazygit. Otherwise fallback to terminal lazygit.
      local ok, snacks = pcall(require, "snacks")
      if ok and snacks.lazygit then
        snacks.lazygit()
      else
        vim.cmd("horizontal split | wincmd J | resize 15 | terminal lazygit")
      end
    elseif vcs == "hg" then
      -- Trigger Figtree if it exists, otherwise fallback to terminal hg status
      if vim.fn.exists(":Figtree") == 2 then
        vim.cmd("Figtree")
      else
        vim.cmd("horizontal split | wincmd J | resize 15 | terminal hg status")
      end
    elseif vcs == "jj" then
      vim.cmd("horizontal split | wincmd J | resize 15 | terminal jj status")
    elseif vcs == "p4" then
      vim.cmd("horizontal split | wincmd J | resize 15 | terminal p4 status")
    else
      vim.notify("No active VCS detected in current workspace.", vim.log.levels.WARN)
    end
  end, { desc = "VCS Status Panel" })

  -- 2. Unified VCS Diff View - Local Changes vs Immediate Parent (<leader>gd)
  vim.keymap.set("n", "<leader>gd", function()
    local vcs = get_vcs_type()
    if vcs == "git" then
      vim.cmd("DiffviewOpen")
    elseif vcs == "hg" then
      -- Diff only uncommitted changes vs immediate local parent (.)
      vim.cmd("DiffviewOpen .")
    elseif vcs == "jj" then
      -- Diff only uncommitted changes vs immediate local parent (@-)
      vim.cmd("DiffviewOpen @-")
    elseif vcs == "p4" then
      vim.cmd("DiffviewOpen")
    else
      vim.notify("No active VCS detected in current workspace.", vim.log.levels.WARN)
    end
  end, { desc = "VCS Diff Local vs Parent" })

  -- 2b. Unified VCS Diff View - All Stack Changes vs Upstream Base (<leader>gb)
  vim.keymap.set("n", "<leader>gb", function()
    local vcs = get_vcs_type()
    if vcs == "git" then
      -- Diff against upstream tracking branch
      vim.cmd("DiffviewOpen @{u}...HEAD")
    elseif vcs == "hg" then
      -- Diff entire local stack/CL vs p4base submitted revision
      vim.cmd("DiffviewOpen p4base..")
    elseif vcs == "jj" then
      -- Diff entire local stack vs p4base
      vim.cmd("DiffviewOpen p4base..")
    elseif vcs == "p4" then
      vim.cmd("DiffviewOpen")
    else
      vim.notify("No active VCS detected in current workspace.", vim.log.levels.WARN)
    end
  end, { desc = "VCS Diff Stack vs Upstream Base" })

  -- 3. Unified VCS Commit/Describe (<leader>gc)
  vim.keymap.set("n", "<leader>gc", function()
    local vcs = get_vcs_type()
    local cmd
    if vcs == "git" then
      cmd = "git commit"
    elseif vcs == "hg" then
      cmd = "hg commit"
    elseif vcs == "jj" then
      cmd = "jj describe"
    elseif vcs == "p4" then
      cmd = "g4 change"
    end

    if cmd then
      vim.cmd("horizontal split | wincmd J | resize 15 | terminal " .. cmd)
    else
      vim.notify("No active VCS detected in current workspace.", vim.log.levels.WARN)
    end
  end, { desc = "VCS Commit" })

  -- 4. Unified VCS Sync/Push (<leader>gp)
  vim.keymap.set("n", "<leader>gp", function()
    local vcs = get_vcs_type()
    local cmd
    if vcs == "git" then
      cmd = "git push"
    elseif vcs == "hg" then
      cmd = "hg sync"
    elseif vcs == "jj" then
      cmd = "jj sync"
    elseif vcs == "p4" then
      cmd = "g4 sync"
    end

    if cmd then
      vim.cmd("horizontal split | wincmd J | resize 15 | terminal " .. cmd)
    else
      vim.notify("No active VCS detected in current workspace.", vim.log.levels.WARN)
    end
  end, { desc = "VCS Sync / Push" })

  -- 5. Unified VCS Hunk Navigation (Mnemonic: j/k for vertical, g for VCS)
  vim.keymap.set("n", "<leader>gj", function()
    if vim.wo.diff then
      vim.cmd("normal! ]c")
    else
      local vcs = get_vcs_type()
      if vcs == "git" then
        local ok, gs = pcall(require, "gitsigns")
        if ok then
          gs.nav_hunk("next")
        end
      else
        vim.notify("Hunk navigation not supported in normal buffers for this VCS.", vim.log.levels.WARN)
      end
    end
  end, { desc = "VCS Next Hunk" })

  vim.keymap.set("n", "<leader>gk", function()
    if vim.wo.diff then
      vim.cmd("normal! [c")
    else
      local vcs = get_vcs_type()
      if vcs == "git" then
        local ok, gs = pcall(require, "gitsigns")
        if ok then
          gs.nav_hunk("prev")
        end
      else
        vim.notify("Hunk navigation not supported in normal buffers for this VCS.", vim.log.levels.WARN)
      end
    end
  end, { desc = "VCS Prev Hunk" })
end

-- Automatically run setup on load
M.setup()

return M
