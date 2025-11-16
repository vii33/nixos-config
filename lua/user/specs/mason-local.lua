return {
  -- Disable Mason entirely since Nix manages all LSP/tools
  {
    "mason-org/mason.nvim", 
    enabled = false,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    enabled = false,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    enabled = false,
  },
}
