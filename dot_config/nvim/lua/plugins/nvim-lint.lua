return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Force shellcheck to use stdin
    -- This might not be needed in the future, but it is for now sadness
    lint.linters.shellcheck.stdin = true
    lint.linters.shellcheck.args = {
      "--format",
      "json1",
      "-", -- This tells shellcheck to read from stdin
    }

    -- Configure linters by filetype
    lint.linters_by_ft = {
      -- Add linters you want to use
      -- python = { "pylint" },
      -- javascript = { "eslint_d" },
      -- sh = { "shellcheck" },
      markdown = { "markdownlint-cli2" },
      cpp = { "clangtidy" },
      c = { "clangtidy" },
    }

    -- Auto-lint on save and when entering buffer
    local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

    -- vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "TextChanged", "InsertLeave" }, {
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
      group = lint_augroup,
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
