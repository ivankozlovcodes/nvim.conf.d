# User Neovim Configuration Summary

This document summarizes the established keymap conventions and environmental details for the user's Neovim setup.

## Keymap Conventions

### Finding (Files, Grep, Buffers) - `<leader>f`
- `<leader>ff`: Find Files (Uses CodeSearch in Google3, standard picker elsewhere).
- `<leader>fg`: Live Grep (Uses CodeSearch in Google3).
- `<leader>fb`: Buffer Picker.
- `<leader>fr`: Recent Files.
- `<leader>fe`: Find Config Files (Searches repo root and `stdpath('config')`).
- `<leader>fl`: Find Files Locally.

### Searching (Symbols, Keymaps, Workspaces) - `<leader>s`
- `<leader>ss`: Document Symbols (LSP).
- `<leader>sk`: Search Keymaps.
- `<leader>sw`: Search Modified Files (CITC in Google3, Git status elsewhere).
- `<leader>sc`: Search CITC Workspaces.
- `<leader>S`: Global Search & Replace (word under cursor).

### LSP & Diagnostics - `<leader>l`
- `<leader>lh`: LSP Hover.
- `<leader>ld`: Diagnostic float.
- `<leader>la`: Code Action.
- `<leader>lj`: Next diagnostic.
- `<leader>lk`: Prev diagnostic.

### Core Ergonomics
- `<leader>bb`: Switch to Last Buffer.
- `<leader>bk`: Backup current buffer (creates `<file>.bak`).
- `<leader>e`: Toggle File Explorer (Fyler).
- `<leader>cc`: Toggle Color Column (80).
- `<leader>qa`: Wipe all buffers and fallback to Alpha dashboard.
- `<leader>pa`: Copy absolute path of current file.
- `H/J/K/L`: Window navigation (mapped to `<C-w>h/j/k/l` in some contexts, but primarily use `<C-h/j/k/l>`).
- `;`: Mapped to `:` for faster command entry.

## Environment
- **Google3**: Heavy integration with CodeSearch and CITC.
- **Submodules**: Work-specific config is isolated in `lua/myconfig/goog` (submodule).
- **Plugins**: Uses `lazy.nvim`, `telescope`, `snacks`, `conform`, `nvgoog`.
