---
name: nvim-helper
description: Guide for managing and troubleshooting Neovim configuration, workspaces, and Google-specific integrations.
---

# Neovim Config Helper

This skill provides a breakdown of the Neovim setup, lists important configuration folders, and defines a set of commands to control the agent's behavior during troubleshooting and development.

## Neovim Setup Breakdown

The configuration is modular and workspace-aware, allowing switching between different setups (e.g., personal and work).

### Core Structure
- **Entry Point (`~/.config/nvim/init.lua`)**: Bootstraps `lazy-workspaces.nvim` and sets global options.
- **Workspace Manager (`lazy-workspaces.nvim`)**: Dynamically loads specific configurations based on the active workspace.
- **Google Defaults (`nvgoog`)**: Located at `~/git/nvgoog`. Contains Google-specific plugins and settings (CiderLSP, Telescope with Code Search/CitC, etc.).

### Important Folders
- **Personal Config**: `~/git/nvim.conf.d` (Workspace: `personal`)
- **Work Config**: `~/git/nvim.goog.d` (Workspace: `work`)
- **Google Core**: `~/git/nvgoog` (Shared Google-specific configuration)
- **Nvim Home**: `~/.config/nvim` (Bootstrap and entry point)

### Keymap Philosophy
Your keymap philosophy is mapped out in detail in [keymap_philosophy.md](file:///usr/local/google/home/ivankozlov/git/nvim.conf.d/.agents/keymap_philosophy.md). Always consult this document before proposing, editing, or adding any new keymaps. Respect the semantic prefixes (e.g., `s` for Search, `g` for VCS/Google, `t` for Toggles) and follow the VCS unification design pattern.

---

## Agent Commands

The following commands must be respected at all times. A command is a single ALL_CAPS word anywhere in the prompt. Commands only affect the current prompt unless specified otherwise.

### `FIX`
- **Action**: The agent is being asked to fix an issue.
- **Permissions**: Code changes and file modifications are **allowed**.
- **Instructions**: Identify the root cause, apply the fix, verify it, and report back.

### `COMMIT`
- **Action**: Commit the current changes.
- **Permissions**: The agent is **NOT allowed to edit code** in this phase.
- **Instructions**: Use `git commit` to commit the changes. The commit message must follow standard good practices (similar to existing git log examples in the repository).

### `WHY`
- **Action**: Explain a behavior or issue.
- **Permissions**: The agent **must NOT edit code or commit**. This is a review/explanation stage only.
- **Instructions**: Analyze the issue or code and explain "why" it happens or how it works.

---

## Workspace and Commit Guidelines

- **Workspace Ambiguity**: If a file can be edited or added to multiple workspaces (e.g., personal vs work, or shared `nvgoog`), **always ask the user for explicit instructions** before making changes.
- **Commit Destination**: If a change can be committed to multiple repositories (e.g., `nvim.conf.d`, `nvim.goog.d`, or `nvgoog`), **always ask the user where to commit** the changes.
