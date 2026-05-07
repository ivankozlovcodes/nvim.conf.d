# nvim.conf.d

Modular Neovim config. Consumed as a lazy.nvim plugin — not a standalone config.

Splits into three layers: **common** (options, keymaps, autocmds), **personal** (plugins + personal bindings), **work** (overrides, empty by default).

## Bootstrap

On a clean machine:

```sh
curl -fsSL https://raw.githubusercontent.com/ivankozlovcodes/nvim.conf.d/main/bootstrap.sh | sh
```

Writes `~/.config/nvim/init.lua` and exits. Open `nvim` — lazy installs everything automatically.

## Test without touching your config

```sh
nvim -u /path/to/nvim.conf.d/sandbox/init.lua
```

Lazy and plugins install into `.sandbox/` — isolated from your main Neovim install.

## Structure

```
lua/myconfig/
├── common/
│   ├── init.lua          # M.setup(): options, keymaps, autocmds
│   └── plugins/          # shared plugins (one file each)
├── personal/
│   ├── init.lua          # M.setup(): personal keymaps
│   └── plugins/          # personal plugins + workspace overrides
└── work/
    ├── init.lua          # placeholder
    └── plugins/          # placeholder
```
