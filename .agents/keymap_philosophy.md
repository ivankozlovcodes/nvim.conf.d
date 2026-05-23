# Neovim Keymap Philosophy

This document maps out the keymap philosophy of this Neovim configuration, detailing the mnemonic groups, unified behaviors, and identified conflicts. Respect these guidelines when proposing or adding new keymaps.

## Core Philosophy

1.  **Space as Leader**: The space bar (`" "`) is the universal leader key.
2.  **Mnemonic Prefixes**: Keymaps are grouped logically under single-letter prefixes that match the action's name (e.g., `s` for Search, `g` for Git/VCS, `t` for Toggles).
3.  **VCS Unification**: Keymaps for Version Control are **completely unified**. The same keymap performs the equivalent logical action regardless of whether the active repository is Git, Mercurial (Hg), Jujutsu (jj), or Perforce (CitC/g4).
4.  **Seamless Navigation**: Overrides standard window navigation with `<C-h/j/k/l>` for frictionless movement.

---

## Mnemonic Groups

### 1. `s` → Search & Telescope
Used for all search, navigation, and Telescope operations.
*   `<leader>s` (Prefix) -> Telescope & Search group.
*   `<c-p>` -> Find files (standard shortcut).
*   `<leader>sb` -> Search open buffers.
*   `<leader>sg` -> Live grep in project.
*   `<leader>ss` -> Google Code Search (global).
*   `<leader>sw` -> Search modified files in CitC or Git.
*   `<leader>sr` -> Search recently opened files.
*   *Conflict*: `<leader>s` is also mapped globally in normal mode to search-and-replace the word under the cursor (`:%s/...`). This causes a slight delay when using Telescope prefixes.

### 2. `g` → VCS & Google
Used for Version Control System (Git/Hg/JJ/P4) operations and Google-specific integrations.
*   `<leader>gg` -> Unified VCS Status Panel (Lazygit, Figtree, or terminal status).
*   `<leader>gd` -> Unified VCS Diff (Local vs Parent) using `DiffviewOpen`.
*   `<leader>gb` -> Unified VCS Diff (Entire local stack vs Upstream Base).
*   `<leader>gc` -> Unified VCS Commit / Describe.
*   `<leader>gp` -> Unified VCS Sync / Push.
*   `<leader>gt` / `<leader>ga` -> Google Terms comment integration (goog-terms.nvim).

### 3. `b` → Blaze & Buffers (Dual Purpose)
This prefix serves two distinct semantic groups depending on the context:
*   **Blaze (Work/Google)**:
    *   `<leader>bb` -> Blaze build.
    *   `<leader>bt` -> Blaze test.
    *   `<leader>bf` -> Blaze test current file.
    *   `<leader>be` -> Blaze load errors into quickfix.
    *   `<leader>bl` -> Blaze view command log.
*   **Buffers (Global)**:
    *   `<leader>bq` -> Close current buffer.
    *   `<leader>bl` -> Switch to last buffer.
    *   `<leader>bd` -> Close all buffers except current.
    *   `<leader>bk` -> Backup current buffer (creates `<file>.bak`).

### 4. `l` → LSP & Diagnostics
Used for Language Server Protocol and code diagnostics.
*   `<leader>lh` / `K` -> LSP Hover / Documentation.
*   `<leader>le` -> Open floating diagnostics.
*   `<leader>la` / `gra` -> Code Actions.
*   `gd` -> Goto Definition.
*   `grr` / `gr` -> Goto References (populates quickfix).
*   `grn` -> Rename symbol.
*   `[d` / `]d` -> Navigate to prev/next diagnostic.

### 5. `t` → Toggles
Used for quickly toggling UI features and options.
*   `<leader>tw` -> Toggle line wrap.
*   `<leader>tc` -> Toggle colorcolumn (80 chars).
*   `<leader>tW` -> Toggle diagnostic warnings visibility.
*   `<leader>tN` -> Toggle centered layout (NoNeckPain).

### 6. `q` → Quickfix & Quitting
Used for Quickfix list management and quick quits.
*   `<leader>qo` / `<leader>qc` -> Open / Close Quickfix window.
*   `<leader>qfc` -> Clear Quickfix list.
*   `<leader>qfe` / `<leader>qfw` -> Send diagnostics Errors / Warnings to Quickfix.
*   `<leader>qa` -> Save all and quit (`:xa`).

### 7. `p` → Paths
Used for path operations.
*   `<leader>pa` -> Copy absolute path of current file.
*   `<leader>pw` -> Copy workspace-relative path of current file.
*   `<leader>fd` -> `cd` to current file's directory.

### 8. `n` → Notes / Obsidian
Used for Markdown/Obsidian notes management (via `obsidian.nvim` in `common` setup).
*   `<leader>nn` -> Create a new note (`:ObsidianNew`).
*   `<leader>ns` -> Search vault for tags or text (`:ObsidianSearch`).
*   `<leader>nb` -> View backlinks for the current note (`:ObsidianBacklinks`).
*   `<leader>nc` -> Toggle checklist items inside Markdown buffers.

*Note on `<leader>o`*: The `<leader>o` mapping is globally reserved for **Lspsaga Outline** (`:Lspsaga outline`), which is why the Notes group uses the `n` prefix to avoid conflict.

---

## VS Code Compatibility

To ease the transition or shared usage with VS Code, select familiar mappings are implemented in the `vscode` workspace:
*   `<C-\>` (Normal, Insert, Visual, Terminal) -> Vertical Split (`:vsplit`). This matches the default VS Code behavior to split the editor vertically.

---

## Keymap Design Rules for Agents

1.  **Do not conflict with existing groups**: Before adding a keymap, ensure it fits into the existing mnemonic groups (`s`, `g`, `b`, `l`, `t`, `q`, `p`).
2.  **Favor standard overrides**: For core editing features, favor standard Neovim overrides (like `J/K` in visual mode to move blocks, or `<Esc>` to clear highlights).
3.  **VCS keymaps must be unified**: If adding a VCS feature, implement it in `myconfig/experimental/vcs.lua` using the `get_vcs_type()` helper to support all 4 VCS environments.
