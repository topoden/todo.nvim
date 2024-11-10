local file_name = "my.todo"

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = file_name,
  callback = function()
    require("todo").enable()
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = file_name,
  callback = function()
    require("todo").disable()
  end,
})
