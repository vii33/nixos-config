-- Override LazyVim to use nixd instead of nil for Nix files
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable nil
        nil_ls = {
          enabled = false,
        },
        -- Use nixd instead (managed by Nix)
        nixd = {},
      },
    },
  },
}
