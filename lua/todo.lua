local M = {}

local move_soon = function()
  vim.cmd("normal! ddgg/SOON\rp")
  vim.cmd("nohlsearch")
end

local move_today = function()
  vim.cmd("normal! ddgg/TODAY\rp")
  vim.cmd("nohlsearch")
end

M.add = function()
  vim.fn.matchadd("@markup.heading", "\\<INBOX\\>")
  vim.fn.matchadd("@markup.heading", "\\<TODAY\\>")
  vim.fn.matchadd("@markup.heading", "\\<SOON\\>")

  vim.keymap.set('n', 'ms', move_soon)
  vim.keymap.set('n', 'mt', move_today)
end

M.remove = function()
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
  M.state.add = set_command(M.state.filename, M.state.add, "BufEnter", function() require("todo").add() end)
  M.state.rem = set_command(M.state.filename, M.state.rem, "BufLeave", function() require("todo").remove() end)
end

return M
