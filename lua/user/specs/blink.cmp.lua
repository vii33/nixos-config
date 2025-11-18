-- Custom keymaps and plugin specs
-- Add your LazyVim plugin overrides and custom plugins here

return {
  -- Configure TAB for completion (hybrid behavior) with blink.cmp
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "hide" },
        ["<C-e>"] = { "hide" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<Tab>"] = { "accept", "fallback" },
      },
    },
  },
}
