#!/usr/bin/env sh
set -e

NVIM_CONFIG="$HOME/.config/nvim"
INIT="$NVIM_CONFIG/init.lua"

show_help() {
  echo "Usage: ./bootstrap.sh [module1] [module2] ..."
  echo ""
  echo "Available modules:"
  for dir in lua/myconfig/*; do
    if [ -d "$dir" ]; then
      basename "$dir"
    fi
  done
  echo ""
  echo "Example: ./bootstrap.sh common personal"
  exit 0
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  show_help
fi

if [ -f "$INIT" ]; then
  echo "~/.config/nvim/init.lua already exists. Aborting."
  exit 1
fi

# Determine requested modules
REQUESTED="$@"
if [ -z "$REQUESTED" ]; then
  echo "No modules specified. Loading all available modules by default."
  REQUESTED="common personal goog"
fi

# Configuration generation with fixed priority order
MODULES_TO_LOAD=""
PLUGIN_IMPORTS=""
FOUND_ANY=false

# 1. First, process modules in the preferred order if they were requested
PRIORITY_ORDER="common personal goog"
for mod in $PRIORITY_ORDER; do
  for arg in $REQUESTED; do
    if [ "$arg" = "$mod" ]; then
      if [ -d "lua/myconfig/$mod" ]; then
        MODULES_TO_LOAD="${MODULES_TO_LOAD}        require(\"myconfig.$mod\").setup()\n"
        PLUGIN_IMPORTS="${PLUGIN_IMPORTS}    { import = \"myconfig.$mod.plugins\" },\n"
        FOUND_ANY=true
      fi
      break
    fi
  done
done

# 2. Then, process any other requested modules that aren't in the priority list
for arg in $REQUESTED; do
  is_priority=false
  for mod in $PRIORITY_ORDER; do
    if [ "$arg" = "$mod" ]; then is_priority=true; break; fi
  done

  if [ "$is_priority" = "false" ]; then
    if [ -d "lua/myconfig/$arg" ]; then
      MODULES_TO_LOAD="${MODULES_TO_LOAD}        require(\"myconfig.$arg\").setup()\n"
      PLUGIN_IMPORTS="${PLUGIN_IMPORTS}    { import = \"myconfig.$arg.plugins\" },\n"
      FOUND_ANY=true
    else
      echo "Warning: Module '$arg' not found in lua/myconfig/. Skipping."
    fi
  fi
done

if [ "$FOUND_ANY" = "false" ]; then
  echo "Error: No valid modules found. Aborting."
  exit 1
fi

mkdir -p "$NVIM_CONFIG"

cat > "$INIT" << EOF
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
  dev = { path = "~/git", fallback = true },
  spec = {
    -- Internal Google plugins (Load first for theme defaults)
    {
      url = "sso://user/fentanes/nvgoog",
      import = "nvgoog.default",
      enabled = $(echo "$REQUESTED" | grep -q "goog" && echo "true" || echo "false"),
    },
    {
      "ivankozlovcodes/nvim.conf.d",
      dev = true,
      lazy = false,
      priority = 1000,
      config = function()
$(printf "$MODULES_TO_LOAD")
      end,
    },
$(printf "$PLUGIN_IMPORTS")
  },
  change_detection = { notify = false },
})
EOF

echo "Done. Created $INIT"
echo "Open nvim — lazy will install everything automatically."
