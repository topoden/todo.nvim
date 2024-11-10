local M = {}

local move_soon = function()
  vim.cmd("normal! ddgg/SOON\rp")
  vim.cmd("nohlsearch")
end

local move_today = function()
  vim.cmd("normal! ddgg/TODAY\rp")
  vim.cmd("nohlsearch")
end

M.enable = function()
  vim.fn.matchadd("@markup.heading", "\\<INBOX\\>")
  vim.fn.matchadd("@markup.heading", "\\<TODAY\\>")
  vim.fn.matchadd("@markup.heading", "\\<SOON\\>")

  vim.keymap.set('n', 'ms', move_soon)
  vim.keymap.set('n', 'mt', move_today)
end

M.disable = function()
  vim.keymap.del('n', 'ms')
  vim.keymap.del('n', 'mt')
end

return M
