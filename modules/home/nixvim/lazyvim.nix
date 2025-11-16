{ config, pkgs, ... }:
{

  programs.nixvim = {
    enable = true;
    vimAlias = true;

    lsp = {
      servers = {
        bashls.enable     = true;
        dockerls.enable   = true;
        # helm-ls.enable    = true;
        html.enable       = true;
        jsonls.enable     = true;
        lua_ls.enable     = true;
        nixd.enable       = true;
      };
    };

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
      
      -- Also update package.path for Lua module loading
      package.path = devdir .. "/lua/?.lua;" .. devdir .. "/lua/?/init.lua;" .. package.path

      -- Bootstrap Lazy with LazyVim (following official starter pattern)
      local specs = {
        -- LazyVim itself with its plugins import
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        
        -- (optional) LazyVim extras you actually want
        { import = "lazyvim.plugins.extras.lang.python" },
        -- { import = "lazyvim.plugins.extras.ui.mini-starter" },
      }
      
      -- Your custom plugins/overrides (writable at runtime)
      -- Load user specs directly instead of using lazy's import
      local ok, user_specs = pcall(require, "user.specs")
      if ok and user_specs then
        for _, spec in ipairs(user_specs) do
          table.insert(specs, spec)
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
