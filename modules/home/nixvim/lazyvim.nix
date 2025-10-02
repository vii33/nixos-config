{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # External CLIs you want at runtime:
    extraPackages = with pkgs; [ 
        ripgrep fd nodejs_20 git 
    ];
  };

  programs.nixvim = {
    enable = true;
    # We only need lazy.nvim itself from Nix; the rest is managed by Lazy at runtime
    plugins.lazy.enable = true;

    extraLuaConfig = ''
      -- Leader first (LazyVim expects it):
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- Put a writable dir on the runtimepath for your specs
      local devdir = vim.fn.expand("~/.config/nvim-local")
      if vim.fn.isdirectory(devdir) == 1 then
        vim.opt.rtp:prepend(devdir)
      end

      -- Bootstrap Lazy with LazyVim defaults + your overrides
      require("lazy").setup({
        spec = {
          -- 1) Pull ALL LazyVim defaults:
          { import = "lazyvim.plugins" },

          -- 2) (optional) LazyVim extras you actually want, uncomment as needed:
          -- { import = "lazyvim.plugins.extras.lang.python" },
          -- { import = "lazyvim.plugins.extras.lang.rust" },
          -- { import = "lazyvim.plugins.extras.ui.mini-starter" },

          -- 3) Your overrides/additions live here (writable):
          { import = "user.specs" },
        },
        defaults = { lazy = false, version = false },
        change_detection = { notify = false },
        checker = { enabled = false },  -- disable background update checks if you prefer
      })
    '';
  };
}
