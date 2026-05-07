#!/usr/bin/env sh
set -e

NVIM_CONFIG="$HOME/.config/nvim"
INIT="$NVIM_CONFIG/init.lua"

if [ -f "$INIT" ]; then
  echo "~/.config/nvim/init.lua already exists. Aborting."
  exit 1
fi

mkdir -p "$NVIM_CONFIG"

cat > "$INIT" << 'EOF'
-- Must be set before lazy loads any plugin
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "ivankozlovcodes/nvim.conf.d",
      lazy = false,
      priority = 1000,
      config = function()
        require("myconfig.common").setup()
        require("myconfig.personal").setup()
        -- require("myconfig.work").setup()
      end,
    },
    { import = "myconfig.common.plugins" },
    { import = "myconfig.personal.plugins" },
    -- { import = "myconfig.work.plugins" },
  },
  change_detection = { notify = false },
})
EOF

echo "Done. Open nvim — lazy will install everything automatically."
