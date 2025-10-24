-- Starter user plugin specifications for LazyVim with Nixvim
-- Copy this to: ~/.config/nvim-local/lua/user/specs/init.lua
-- 
-- This file allows you to quickly iterate on neovim plugin configurations
-- without rebuilding NixOS. Just edit, save, and run :Lazy sync in neovim.

return {
  -- Uncomment any of the examples below to get started!

  -- ============================================================================
  -- LANGUAGE SUPPORT - Enable LazyVim language extras
  -- ============================================================================
  
  -- { import = "lazyvim.plugins.extras.lang.rust" },
  -- { import = "lazyvim.plugins.extras.lang.go" },
  -- { import = "lazyvim.plugins.extras.lang.typescript" },
  -- { import = "lazyvim.plugins.extras.lang.json" },
  -- { import = "lazyvim.plugins.extras.lang.yaml" },
  -- { import = "lazyvim.plugins.extras.lang.docker" },
  -- { import = "lazyvim.plugins.extras.lang.markdown" },

  -- ============================================================================
  -- UI ENHANCEMENTS
  -- ============================================================================
  
  -- {
  --   import = "lazyvim.plugins.extras.ui.mini-starter",
  -- },

  -- ============================================================================
  -- CUSTOM PLUGINS - Add plugins not in LazyVim
  -- ============================================================================

  -- Example: Add a colorscheme
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   opts = {
  --     flavour = "mocha",
  --     transparent_background = true,
  --   },
  -- },

  -- Example: Add vim-surround for easy surrounding text operations
  -- {
  --   "tpope/vim-surround",
  --   event = "VeryLazy",
  -- },

  -- Example: Add a git blame plugin
  -- {
  --   "f-person/git-blame.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     enabled = true,
  --     message_template = " <author> • <date> • <summary>",
  --     date_format = "%r",
  --   },
  -- },

  -- ============================================================================
  -- OVERRIDE LAZYVIM DEFAULTS
  -- ============================================================================

  -- Example: Customize Telescope settings
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   opts = {
  --     defaults = {
  --       layout_strategy = "vertical",
  --       layout_config = {
  --         prompt_position = "top",
  --         width = 0.9,
  --         height = 0.9,
  --       },
  --       sorting_strategy = "ascending",
  --     },
  --   },
  -- },

  -- Example: Customize Neo-tree (file explorer)
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   opts = {
  --     filesystem = {
  --       filtered_items = {
  --         hide_dotfiles = false,
  --         hide_gitignored = false,
  --       },
  --     },
  --   },
  -- },

  -- ============================================================================
  -- DISABLE LAZYVIM DEFAULTS
  -- ============================================================================

  -- Example: Disable flash.nvim if you don't use it
  -- { "folke/flash.nvim", enabled = false },

  -- Example: Disable mini.ai if you prefer other text objects
  -- { "echasnovski/mini.ai", enabled = false },

  -- ============================================================================
  -- DEVELOPMENT TOOLS
  -- ============================================================================

  -- Example: Add vim-startuptime to measure startup performance
  -- {
  --   "dstein64/vim-startuptime",
  --   cmd = "StartupTime",
  -- },

  -- Example: Add trouble.nvim for better diagnostics
  -- (Note: This might already be in LazyVim, check :Lazy first)
  -- {
  --   "folke/trouble.nvim",
  --   cmd = "Trouble",
  --   opts = {},
  --   keys = {
  --     { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
  --     { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
  --   },
  -- },
}
