return { -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      "nvim-telescope/telescope-fzf-native.nvim",

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = "make",

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    local actions = require("telescope.actions")
    local open_with_trouble = require("trouble.sources.telescope").open
    require("telescope").setup({
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<c-t>"] = open_with_trouble,
          },
          n = { ["<c-t>"] = open_with_trouble },
        },
      },
      pickers = {
        oldfiles = {
          cwd_only = true,
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    local FILE_NAME = "/tmp/disable_telescope_prev"
    local display_preview = function()
      local file = io.open(FILE_NAME)
      if file ~= nil then
        file:close()
        return true
      end
      return false
    end

    vim.keymap.set("n", "<leader>tt", function()
      local file = io.open(FILE_NAME)
      if file ~= nil then
        file:close()
        os.remove(FILE_NAME)
      else
        file = io.open(FILE_NAME, "w")
        if file ~= nil then
          file:write("Disbled telescope prev")
        end
        io.close(file)
      end
    end, { desc = "[T]oggle [T]elescope Preview" })

    local toggle_preview_wrapper = function(fun, opts)
      if opts == nil then
        opts = {}
      end
      if not display_preview() then
        opts.previewer = false
      end
      fun(opts)
    end

    -- Enable Telescope extensions if they are installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
    pcall(require("telescope").load_extension, "live_grep_args")

    -- See `:help telescope.builtin`
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sh", function()
      toggle_preview_wrapper(builtin.help_tags)
    end, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sq", function()
      toggle_preview_wrapper(builtin.quickfix)
    end, { desc = "[S]earch [q]uickfix" })
    vim.keymap.set("n", "<leader>sQ", function()
      toggle_preview_wrapper(builtin.quickfixhistory)
    end, { desc = "[S]earch [q]uickfixlists" })
    vim.keymap.set("n", "<leader>sk", function()
      toggle_preview_wrapper(builtin.keymaps)
    end, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>sf", function()
      toggle_preview_wrapper(builtin.find_files)
    end, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>ss", function()
      toggle_preview_wrapper(builtin.builtin)
    end, { desc = "[S]earch [S]elect Telescope" })
    vim.keymap.set("n", "<leader>sw", function()
      toggle_preview_wrapper(builtin.grep_string)
    end, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sg", function()
      toggle_preview_wrapper(builtin.live_grep)
    end, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sG", function()
      toggle_preview_wrapper(require("telescope").extensions.live_grep_args.live_grep_args)
    end, { noremap = true, desc = "Live Grep with Args" })
    vim.keymap.set("n", "<leader>sd", function()
      toggle_preview_wrapper(builtin.diagnostics)
    end, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sDe", function()
      toggle_preview_wrapper(builtin.diagnostics, { severity = vim.diagnostic.severity.ERROR })
    end, { desc = "[S]earch [D]iagnostic [E]rrors" })
    vim.keymap.set("n", "<leader>sDi", function()
      toggle_preview_wrapper(builtin.diagnostics, { severity = vim.diagnostic.severity.INFO })
    end, { desc = "[S]earch [D]iagnostic [I]nfos" })
    vim.keymap.set("n", "<leader>sDw", function()
      toggle_preview_wrapper(builtin.diagnostics, { severity = vim.diagnostic.severity.WARN })
    end, { desc = "[S]earch [D]iagnostic [W]arns" })
    vim.keymap.set("n", "<leader>sr", function()
      toggle_preview_wrapper(builtin.resume)
    end, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>s.", function()
      toggle_preview_wrapper(builtin.oldfiles)
    end, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set("n", "<leader><leader>", function()
      toggle_preview_wrapper(builtin.buffers)
    end, { desc = "[ ] Find existing buffers" })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set("n", "<leader>/", function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      -- builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
      --   winblend = 10,
      --   previewer = false,
      -- }))
      toggle_preview_wrapper(builtin.current_buffer_fuzzy_find, require("telescope.themes"))
    end, { desc = "[/] Fuzzily search in current buffer" })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set("n", "<leader>s/", function()
      toggle_preview_wrapper(builtin.live_grep, {
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "[S]earch [/] in Open Files" })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set("n", "<leader>sn", function()
      toggle_preview_wrapper(builtin.find_files, { cwd = vim.fn.stdpath("config") })
    end, { desc = "[S]earch [N]eovim files" })
  end,
}
