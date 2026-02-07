-- lua/plugins/rose-pine.lua
return {
  -- "rose-pine/neovim",
  -- name = "rose-pine",
  -- config = function()
  --   vim.cmd("colorscheme rose-pine")
  -- end,
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      auto_integrations = true,
    })
    vim.cmd("colorscheme catppuccin-mocha")
  end,
}
