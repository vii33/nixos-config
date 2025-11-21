-- Custom keymaps and plugin specs
-- Add your LazyVim plugin overrides and custom plugins here

return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<C-<>", function() Snacks.terminal() end, desc = "Toggle Terminal" }, --Ctrl + <   },
  },
}
