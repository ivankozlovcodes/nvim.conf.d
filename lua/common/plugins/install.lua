local root = debug.getinfo(1, "S").source:sub(2):match("(.*)/lua/myconfig/")

return {
  dir = root,
  name = "plugadd",
  lazy = false,
  config = function()
    vim.api.nvim_create_user_command("Install", function(opts)
      local args = vim.split(vim.trim(opts.args), "%s+")
      if #args < 2 then
        vim.notify("Usage: Install <profile> <author/plugin>", vim.log.levels.ERROR)
        return
      end

      local profile = args[1]
      local plugin_spec = args[2]
      local plugin_name = vim.fn.fnamemodify(plugin_spec, ":t"):gsub("%.nvim$", ""):gsub("%.lua$", "")

      local profile_dir = root .. "/lua/myconfig/" .. profile
      if vim.fn.isdirectory(profile_dir) == 0 then
        vim.notify("Unknown profile: " .. profile, vim.log.levels.ERROR)
        return
      end

      local plugins_dir = profile_dir .. "/plugins"
      if vim.fn.isdirectory(plugins_dir) == 0 then
        vim.fn.mkdir(plugins_dir, "p")
      end

      local file_path = plugins_dir .. "/" .. plugin_name .. ".lua"
      if vim.fn.filereadable(file_path) == 1 then
        vim.notify("Already exists: " .. file_path, vim.log.levels.WARN)
        vim.cmd("edit " .. vim.fn.fnameescape(file_path))
        return
      end

      local lines = {
        "return {",
        '  "' .. plugin_spec .. '",',
        "  opts = {},",
        "}",
      }
      vim.fn.writefile(lines, file_path)
      vim.notify("Created: lua/myconfig/" .. profile .. "/plugins/" .. plugin_name .. ".lua", vim.log.levels.INFO)
      vim.cmd("edit " .. vim.fn.fnameescape(file_path))
    end, {
      nargs = "+",
      desc = "Create plugin spec file in a profile",
      complete = function(arglead, cmdline, _)
        local args = vim.split(vim.trim(cmdline), "%s+")
        if #args == 2 then
          local dirs = vim.fn.glob(root .. "/lua/myconfig/*", false, true)
          local profiles = vim.tbl_map(function(p)
            return vim.fn.fnamemodify(p, ":t")
          end, vim.tbl_filter(function(p)
            return vim.fn.isdirectory(p) == 1
          end, dirs))
          return vim.tbl_filter(function(v)
            return v:find(arglead, 1, true) == 1
          end, profiles)
        end
      end,
    })
  end,
}
