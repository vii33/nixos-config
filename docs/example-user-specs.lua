-- Example user plugin specifications for LazyVim
-- Place this file at: ~/.config/nvim-local/lua/user/specs/example.lua
-- Copy and modify as needed for your custom plugins

return {
  -- Example 1: Simple plugin addition
  -- {
  --   "folke/flash.nvim",
  --   event = "VeryLazy",
  --   opts = {},
  --   keys = {
  --     { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  --   },
  -- },

  -- Example 2: Override LazyVim defaults
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   opts = {
  --     defaults = {
  --       layout_strategy = "vertical",
  --       layout_config = { prompt_position = "top" },
  --       sorting_strategy = "ascending",
  --     },
  --   },
  -- },

  -- Example 3: Disable a LazyVim default plugin
  -- { "folke/flash.nvim", enabled = false },

  -- Example 4: Add a new language extra
  -- { import = "lazyvim.plugins.extras.lang.go" },

  -- Uncomment and modify the examples above to customize your neovim setup!
}
