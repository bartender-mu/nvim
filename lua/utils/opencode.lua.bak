local M = {}

function M.run(prompt)
  local cmd = "/home/ux_tlouison/.opencode/bin/opencode " .. vim.fn.shellescape(prompt)
  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Opencode failed: " .. output, vim.log.levels.ERROR)
    return
  end
  -- Open output in new buffer
  vim.cmd('vnew')  -- vertical split
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, '\n'))
  vim.bo[buf].filetype = 'markdown'
  vim.bo[buf].modifiable = false
  vim.api.nvim_buf_set_name(buf, 'Opencode Output')
end

return M