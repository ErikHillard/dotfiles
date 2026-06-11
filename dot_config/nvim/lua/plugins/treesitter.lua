return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- Parsers to keep installed/updated (these install asynchronously)
    local ensure = {
      "bash",
      "c",
      "cpp",
      "diff",
      "html",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "regex",
      "vim",
      "vimdoc",
      "rust",
      "java",
    }
    require("nvim-treesitter").install(ensure)

    -- On the `main` branch highlighting/indent are no longer auto-enabled;
    -- start them per-buffer when a parser is available for the filetype.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local buf = args.buf
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if lang and pcall(vim.treesitter.start, buf, lang) then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
