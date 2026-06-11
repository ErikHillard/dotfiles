return { -- Collection of various small independent plugins/modules
  "echasnovski/mini.nvim",
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require("mini.ai").setup({ n_lines = 500 })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require("mini.surround").setup()

    require("mini.files").setup()
    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require("mini.statusline")
    -- set use_icons to true if you have a Nerd Font
    statusline.setup({
      use_icons = vim.g.have_nerd_font,
      content = {
        -- Just mode and filename on the left, row:column on the right.
        active = function()
          local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
          local filename = statusline.section_filename({ trunc_width = 140 })
          local location = "%2l:%-2v"

          return statusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "MiniStatuslineFilename", strings = { filename } },
            "%=", -- spacer: push the rest to the right
            { hl = mode_hl, strings = { location } },
          })
        end,
      },
    })

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
