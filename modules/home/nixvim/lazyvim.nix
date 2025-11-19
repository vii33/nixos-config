{ config, pkgs, ... }:
{
  # LazyVim Keymaps: https://www.lazyvim.org/keymaps

  programs.nixvim = {
    enable = true;
    vimAlias = true;
    viAlias = true;

    # Required packages for treesitter and plugin building
    extraPackages = with pkgs; [
      gcc          # C compiler for treesitter parsers
      gnumake      # Build tool
      tree-sitter  # Tree-sitter CLI
      unzip        # Required by Mason for extracting packages
      
      # Snacks.nvim dependencies
      imagemagick  # For 'magick' command (image conversion)
      ghostscript  # For 'gs' command (PDF rendering)
      nodePackages.mermaid-cli  # For 'mmdc' command (Mermaid diagrams)
      
      # Linters and formatters
      markdownlint-cli2  # Markdown linter
      statix       # Nix linter (used by nvim-lint)
      ruff         # Python linter and formatter
    ];

    # LSPs are installed with nix (not mason), due to dynamic linking issues
    lsp = {
      servers = {
        bashls.enable     = true;
        dockerls.enable   = true;
        html.enable       = true;
        jsonls.enable     = true;
        lua_ls.enable     = true;
        nixd.enable       = true;  # Nix LSP (using nixd instead of nil)
        yamlls.enable     = true;

        yamlls = {
          # enable          = true;
          settings = {
            yaml.schemas = {
              kubernetes = "*.yaml";
              "http://json.schemastore.org/github-workflow" = ".github/workflows/*";
              "http://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
              "http://json.schemastore.org/ansible-stable-2.9" = "roles/tasks/*.{yml,yaml}";
              "http://json.schemastore.org/prettierrc" = ".prettierrc.{yml,yaml}";
              "http://json.schemastore.org/kustomization" = "kustomization.{yml,yaml}";
              "http://json.schemastore.org/ansible-playbook" = "*play*.{yml,yaml}";
              "http://json.schemastore.org/chart" = "Chart.{yml,yaml}";
              "https://json.schemastore.org/dependabot-v2" = ".github/dependabot.{yml,yaml}";
              "https://json.schemastore.org/gitlab-ci" = "*gitlab-ci*.{yml,yaml}";
              "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json" = "*api*.{yml,yaml}";
              "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" = "*docker-compose*.{yml,yaml}";
              "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json" = "*flow*.{yml,yaml}";
            };
          };
        };
      };
    };
    

    # Enable lazy.nvim plugin manager
    plugins.lazy.enable = true;
    
    # blink-cmp: Autompletion menu 


    # Enable GitHub Copilot
    #plugins.copilot-lsp.enable = true;
    plugins.copilot-lua = {
      enable = true;
      settings = {
        suggestion = {
          enabled = true;
          autoTrigger = true;
          #keymap = {
          #  accept = "<M-l>";
          #  next = "<M-]>";
          #  prev = "<M-[>";
          #  dismiss = "<C-]>";
          #};
        };
      };

      #panel.enabled = false;
    };

    # Enable lazygit UI
    plugins.lazygit.enable = true;

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
      
      -- Update package.path for Lua module loading
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
