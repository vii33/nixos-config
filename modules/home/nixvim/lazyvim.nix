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

      -- Bootstrap Lazy with LazyVim (following official starter pattern)
      local specs = {
        -- LazyVim itself with its plugins import
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        
        -- (optional) LazyVim extras you actually want
        { import = "lazyvim.plugins.extras.lang.python" },
        -- { import = "lazyvim.plugins.extras.ui.mini-starter" },
      }
      
      -- Your custom plugins/overrides (writable at runtime)
      -- Only import user specs if the directory exists and has files
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
