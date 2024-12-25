local find_header = function(header)
  local buf = 0
  local num_lines = vim.api.nvim_buf_line_count(buf)
  for i = 1, num_lines do
    local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
    if line == header then
      return i
    end
  end
  return nil
end

local move_to = function(header)
  local line_cur = vim.api.nvim_win_get_cursor(0)
  local line_to = find_header(header)
  vim.cmd(string.format("move %d", line_to))
  vim.api.nvim_win_set_cursor(0, line_cur)
end

local move_soon = function()
  move_to("SOON")
end

local move_today = function()
  move_to("TODAY")
end

local M = {}

M.startup = function()
  vim.fn.matchadd("@markup.heading", "\\<INBOX\\>")
  vim.fn.matchadd("@markup.heading", "\\<TODAY\\>")
  vim.fn.matchadd("@markup.heading", "\\<SOON\\>")

  vim.keymap.set('n', 'ms', move_soon)
  vim.keymap.set('n', 'mt', move_today)
end

M.shutdown = function()
  vim.keymap.del('n', 'ms')
  vim.keymap.del('n', 'mt')
end

M.state = {}

local set_command = function(filename, current, event, callback)
  if current ~= nil then
    vim.api.nvim_del_autocmd(current)
  end
  return vim.api.nvim_create_autocmd({ event }, {
    pattern = filename,
    callback = callback,
  })
end

M.setup = function(opts)
  if M.state.filename == opts.filename then
    return
  end
  M.state.filename = opts.filename
  M.state.startup  = set_command(M.state.filename, M.state.startup, "BufEnter", M.startup)
  M.state.shutdown = set_command(M.state.filename, M.state.shutdown, "BufLeave", M.shutdown)
end

return M
