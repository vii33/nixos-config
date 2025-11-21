-- Recovery file when Vim crashes
return {
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      -- Better swap file handling to avoid E325 errors
      vim.opt.swapfile = false  -- Disable swap files for now
      vim.opt.updatetime = 250  -- Faster swap file writes
      
      -- Automatically handle swap files without prompting
      -- 'o' = Open read-only
      
      return opts
    end,
  },
}
