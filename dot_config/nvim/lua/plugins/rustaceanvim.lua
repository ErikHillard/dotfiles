return {
  "mrcjkb/rustaceanvim",
  version = "^8", -- Recommended
  lazy = false, -- This plugin is already lazy
  init = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          -- Override keymaps for Rust files only
          -- These will take precedence over the general LSP keymaps from nvim-lspconfig

          -- Override 'gjd' to use Telescope for definitions (keeping it consistent)
          -- but you could use vim.cmd.RustLsp here if you prefer
          vim.keymap.set("n", "gjd", function()
            require("telescope.builtin").lsp_definitions()
          end, { silent = true, buffer = bufnr, desc = "LSP: [G]oto [D]efinition" })

          -- Override 'gja' to use rustaceanvim's grouped code actions
          vim.keymap.set("n", "gja", function()
            vim.cmd.RustLsp("codeAction")
          end, { silent = true, buffer = bufnr, desc = "LSP: [C]ode [A]ction" })

          -- Override 'K' to use rustaceanvim's hover actions
          vim.keymap.set("n", "K", function()
            vim.cmd.RustLsp({ "hover", "actions" })
          end, { silent = true, buffer = bufnr, desc = "LSP: Hover Actions" })
        end,
      },
      default_settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true, -- Enable all features for better completions [2]
          },
          completion = {
            autoimport = { enable = true }, -- Enable auto import [5]
          },
          checkOnSave = {
            command = "clippy", -- Run clippy on save
          },
        },
      },
    }
  end,
}
