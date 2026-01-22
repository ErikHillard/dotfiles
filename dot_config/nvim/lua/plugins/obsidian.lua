return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see above for full list of optional dependencies ☝️
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    workspaces = {
      {
        name = "life",
        path = "~/vaults/life/",
      },
      {
        name = "Kobolds",
        path = "~/vaults/Kobolds/",
      },
      {
        name = "life",
        path = "~/obsidianVaults/life/",
      },
      {
        name = "Lost_Mines_of_Plandelver",
        path = "~/vaults/Lost_Mines_of_Phandelver/",
      },
    },

    -- see below for full list of options 👇
    completion = {
      blink = true,
    },
    new_notes_location = "current_dir",
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      if title ~= nil then
        return title
      else
        local suffix = ""
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
        return suffix
      end
    end,
    ---@return table
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then
        note:add_alias(note.title)
      end

      local out = { id = note.id, aliases = note.aliases, tags = note.tags }

      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      local has_created = false
      for _, tag in ipairs(out.tags) do
        if tag:match("^created:") then
          has_created = true
          break
        end
      end
      local created = "created:" .. os.date("%Y-%m-%dT%H:%M:%S")
      if not has_created then
        table.insert(out.tags, created)
      end
      return out
    end,
  },
  -- end
}
