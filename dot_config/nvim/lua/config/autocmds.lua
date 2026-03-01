-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Decided that I most of the time turn on diagnostic on hover, not the other way around
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--   desc = "Display diagnostics on hover",
--   group = vim.api.nvim_create_augroup("diagnostic-hover-display", { clear = true }),
--   callback = function()
--     vim.diagnostic.open_float(nil, { focus = false })
--   end,
-- })
local userconfig_group = vim.api.nvim_create_augroup("diagnostic-hover-display", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = userconfig_group,
  desc = "return cursor to where it was last time closing the file",
  pattern = "*",
  command = 'silent! normal! g`"zv',
})
