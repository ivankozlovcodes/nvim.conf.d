return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    picker = {
      enabled = true,
      matcher = {
        frecency = true,
        cwd_bonus = true,
        ignorecase = true,
        fuzzy = true,
      },
      ui_select = true,
      win = {
        input = {
          keys = {
            ["v"] = { "edit_vsplit", mode = { "n" } },
            ["h"] = { "edit_split", mode = { "n" } },
            ["t"] = { "edit_tab", mode = { "n" } },
            ["<Esc>"] = { "close", mode = { "n" } },
          },
        },
      },
    },
    quickfile = { enabled = false },
    notifier = { enabled = false },
    scope = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    rename = { enabled = true },
    zen = { enabled = true },
    gh = { enabled = false },
    lazygit = { enabled = true },
    dim = {
      enabled = true,
      animate = {
        enabled = vim.fn.has("nvim-0.10") == 1,
        easing = "outQuad",
        duration = { step = 20, total = 300 },
      },
      scope = { min_size = 5, max_size = 20, siblings = true },
      filter = function(buf)
        return vim.g.snacks_dim ~= false
          and vim.b[buf].snacks_dim ~= false
          and vim.bo[buf].buftype == ""
      end,
    },
  },
  -- stylua: ignore start
  keys = {
    { "<leader>?",  function() Snacks.picker.help() end, desc = "Search help tags" },
    { "<leader>/", function()
        local items = {}
        for name in pairs(vim.api.nvim_get_commands({})) do
          table.insert(items, { text = name, label = "[cmd] " .. name, kind = "command" })
        end
        for _, mode in ipairs({ "n", "v", "i" }) do
          for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
            local lhs = map.lhs or ""
            local desc = map.desc or ""
            if desc ~= "" or lhs ~= "" then
              table.insert(items, {
                text = lhs .. " " .. desc,
                label = "[" .. mode .. "] " .. lhs .. (desc ~= "" and ("  " .. desc) or ""),
                kind = "keymap", lhs = lhs, mode = mode,
              })
            end
          end
        end
        Snacks.picker.pick({
          title = "Commands & Keymaps",
          items = items,
          format = function(item) return { { item.label } } end,
          confirm = function(picker, item)
            picker:close()
            if item.kind == "command" then vim.cmd(item.text) end
          end,
        })
      end, desc = "Search commands & keymaps" },
    { "<C-S-P>",     function() Snacks.picker.commands() end,                                desc = "Command Palette", nowait = true },
    { "<leader>g/",  function() Snacks.lazygit() end,                                        desc = "Open lazygit" },
    { "<leader>fe",  function() Snacks.picker.files({ dirs = { vim.g.myconfig_root, vim.fn.stdpath("config") } }) end, desc = "Find config file" },
    { "<leader>ff",  function() Snacks.picker.files() end,                                   desc = "Find Files" },
    { "<leader>bb",  function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
    { "<leader>fr",  function() Snacks.picker.recent() end,                                  desc = "Recent" },
    { "<leader>:",   function() Snacks.picker.commands() end,                                desc = "Command Palette" },
    { "<leader>z",   function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
    { "<leader>fg",  function() Snacks.picker.grep() end,                                    desc = "Grep" },
    { "<leader>fgw", function() Snacks.picker.grep_word() end,                               desc = "Grep selected word", mode = { "n", "x" } },
    { "<leader>fp",  function() Snacks.picker.projects() end,                                desc = "Projects" },
    { "<leader>fn",  function() Snacks.picker.notifications() end,                           desc = "Notifications" },
    { "gd",          function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
    { "gD",          function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
    { "gr",          function() Snacks.picker.lsp_references() end,   nowait = true,         desc = "References" },
    { "gI",          function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
    { "gy",          function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
    { "gai",         function() Snacks.picker.lsp_incoming_calls() end,                      desc = "Calls Incoming" },
    { "gao",         function() Snacks.picker.lsp_outgoing_calls() end,                      desc = "Calls Outgoing" },
    { "<leader>ls",  function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
    { "<leader>sd",  function()
        if Snacks.dim.enabled then Snacks.dim.disable() else Snacks.dim.enable() end
      end,                                                                                   desc = "Toggle dim" },
  },
  -- stylua: ignore end
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
}
