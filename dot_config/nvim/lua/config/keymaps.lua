-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>dh", function()
  -- Check if the augroup exists
  local ok, autocmds = pcall(vim.api.nvim_get_autocmds, { group = "diagnostic-hover-display" })
  if ok and #autocmds > 0 then
    -- Disable: delete the augroup
    vim.api.nvim_del_augroup_by_name("diagnostic-hover-display")
    vim.notify("Disabled diagnostic hover display", vim.log.levels.INFO)
  else
    -- Enable: recreate the augroup
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      desc = "Display diagnostics on hover",
      group = vim.api.nvim_create_augroup("diagnostic-hover-display", { clear = true }),
      callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
      end,
    })
    vim.notify("Enabled diagnostic hover display", vim.log.levels.INFO)
  end
end, { desc = "Toggle [D]iagnostic [H]over display" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down half a page and center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move down half a page and center cursor" })
-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })
vim.keymap.set("n", "<C-n>", ":cnext<CR>", { desc = "Quickfix Next", silent = true })
vim.keymap.set("n", "<C-p>", ":cprev<CR>", { desc = "Quickfix Prev", silent = true })

-- claude
vim.keymap.set("n", "<leader>cq", ':terminal ?? ""<Left>', { desc = "Pull up a claude question in a new terminal" })
vim.keymap.set("n", "<leader>ccq", ':terminal ??? ""<Left>', { desc = "Pull up a claude question in a new terminal" })
vim.keymap.set("n", "<leader>cp", ':r ?? ""<Left>', { desc = "Read a claude question into the buffer" })

vim.keymap.set("n", "<leader>tq", function()
  local qf_exists = vim.iter(vim.fn.getwininfo()):any(function(wininf)
    return winfin.quickfix == 1
  end)
  if qf_exists then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end, { desc = "Toggle quickfix list" })
