vim.api.nvim_create_user_command('Remember', function(opts)
  -- Searches through active mappings for the given command name
  vim.cmd('filter /' .. opts.args .. '/ map')
end, { nargs = 1 })

