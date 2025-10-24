{ config, pkgs, ... }:
{

  programs.nixvim = {
    enable = true;
    # Enable lazy.nvim plugin manager
    plugins.lazy.enable = true;

    extraConfigLua = ''
      -- Leader first (LazyVim expects it):
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- Put a writable dir on the runtimepath for your specs
      local devdir = vim.fn.expand("~/.config/nvim-local")
      if vim.fn.isdirectory(devdir) == 0 then
        vim.fn.mkdir(devdir .. "/lua/user/specs", "p")
      end
      vim.opt.rtp:prepend(devdir)

      -- Bootstrap Lazy with LazyVim defaults + your overrides
      local specs = {
        -- 0) LazyVim itself (let Lazy manage it for latest version):
        {
          "LazyVim/LazyVim",
          priority = 10000,
          lazy = false,
          opts = {},
          version = false, -- always use latest
        },
        
        -- 1) Pull ALL LazyVim defaults:
        { import = "lazyvim.plugins" },

        -- 2) (optional) LazyVim extras you actually want, uncomment as needed:
        { import = "lazyvim.plugins.extras.lang.python" },
        -- { import = "lazyvim.plugins.extras.lang.rust" },
        -- { import = "lazyvim.plugins.extras.ui.mini-starter" },
      }
      
      -- 3) Your overrides/additions live here (writable):
      -- Only import user specs if the directory exists
      local user_specs_path = vim.fn.expand("~/.config/nvim-local/lua/user/specs")
      if vim.fn.isdirectory(user_specs_path) == 1 then
        local has_files = vim.fn.glob(user_specs_path .. "/*.lua") ~= ""
        if has_files then
          table.insert(specs, { import = "user.specs" })
        end
      end

      require("lazy").setup({
        spec = specs,
        defaults = { lazy = false, version = false },
        change_detection = { notify = false },
        checker = { enabled = false },  -- disable background update checks if you prefer
      })
    '';
  };
}
