{ pkgs, config, nixvim, lib, ...}:
{

  imports = [

  ];

  programs.bash.bashrcExtra = ''
    EDITOR=nvim
  '';

  programs.nixvim = {
    enable    = true;
    viAlias   = true;
    vimAlias  = true;

    clipboard.register = "unnamedplus";

    colorschemes.catppuccin = {
      enable 	              = true;


      settings = {
        transparent_background = true;
        flavour = "mocha";
        integrations = {
          barbar      = true;
          cmp         = true;
          gitsigns    = true;
          noice       = true;
          notify      = true;
          nvimtree    = true;
          treesitter  = true;
        };
      };
    };

    highlight = {
      DapBP         = { fg = "#7bcc40";};
      DapST         = { fg = "#f47722"; };
      VisualNonText = { fg = "#2be6d2"; };
    };

    opts = {
      number          = true;
      relativenumber  = true;
      expandtab       = true;
      tabstop	        = 2;
      shiftwidth      = 2;
    };

    extraPlugins = with pkgs.vimPlugins; [
      vim-hcl
      vim-flog
      vim-helm
      vim-gitbranch
      vim-airline-themes
    ];

    extraConfigLua = ''
      -- APPEARANCE
      vim.api.nvim_set_hl(0, 'LineNr', { fg = "#35b6e6" })

      --   Cursor style
      vim.o.guicursor = 'n-v-c-sm:block,i:ver100-iCursor-blinkon1-blinkwait10'

      require('gitsigns').setup()
    '';

    lsp = {
      servers = {
        bashls.enable     = true;
        dockerls.enable   = true;
        helm-ls.enable    = true;
        html.enable       = true;
        jsonls.enable     = true;
        lua_ls.enable     = true;
        nixd.enable       = true;
        yamlls.enable     = lib.mkForce true;

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


    plugins = {
      barbar.enable             = true;
      telescope.enable          = true;
      lsp.enable                = true;
      blink-cmp.enable          = true;
      airline.enable            = true;
      dap.enable                = true;
      diffview.enable           = true;
      fugitive.enable           = true;
      gitsigns.enable           = true;
      indent-blankline.enable   = true;
      lualine.enable            = true;
      luasnip.enable            = true;
      markview.enable           = true;
      neotest.enable            = true;
      notify.enable             = true;
      rainbow-delimiters.enable = true;
      toggleterm.enable         = true;
      whitespace.enable  = true;
      web-devicons.enable       = true;
      which-key.enable          = true;

      barbar = {
        settings.animation = true;
      };

      airline = {
        settings = {
          powerline_fonts = 1;
          theme = "base16_dracula";
        };
      };

      dap = {
        signs = {
          dapBreakpoint =  { text="◉"; texthl="DapBP"; linehl=""; numhl=""; };
          dapStopped =  { text="◉"; texthl="DapST"; linehl="DapST"; numhl="DapST"; };
        };
      };

      telescope = {
        settings = {
          pickers.find_files = {
            hidden = true;
            theme = "dropdown";
          };

          defaults = {
            file_ignore_patterns = [
              "node_modules"
              "dist"
              ".git/"
              ".cache/"
            ];
          };
        };
        extensions = {
          file-browser.enable = true;
          fzf-native.enable   = true;
        };
      };

      blink-cmp = {
        settings = {
          keymap = {
            "<Tab>" = [ "select_next" "fallback" ];
            "<S-Tab>" = [ "select_prev" "fallback" ];
            "<A-CR>" = [ "select_and_accept" ];
            "<C-j>" = [ "scroll_documentation_down" ];
            "<C-k>" = [ "scroll_documentation_up" ];
          };

          completion = {
            menu = {
              border = "single";
            };
            documentation = {
              auto_show = true;
              window.border = "single";
            };
          };

          sources.default = [ "lsp" "path" "snippets" "buffer" ];
        };
      };

      whitespace = {
        settings = {
          hightlight = "ColoredWhitespace";
          ignore_terminal = true;
          return_cursor = true;
        };
      };
    };

    keymaps = [
      # Navigation
      { mode = "n"; action = "<cmd>b#<cr>"; key="<C-b>"; }

      # Nvim-tree
      { mode = "n"; action = "<cmd>NvimTreeToggle<cr>"; key = "<C-M-b>"; }

      # Telescope
      { mode = "n"; action = "<cmd>Telescope find_files<cr>"; key = "<C-M-p>"; }
      { mode = "n"; action = "<cmd>Telescope live_grep<cr>"; key="<leader>lg"; }

      # Terminal
      { mode = "t"; action = "<C-\\><C-n>"; key = "<esc>"; }
      { mode = ["t" "n"]; action = "<cmd>ToggleTerm<cr>"; key = "<C-M-k>"; }

      # Barbar
      { mode = ["n" "i"]; action = "<cmd>BufferPrevious<cr>"; key = "<A-h>"; }
      { mode = ["n" "i"]; action = "<cmd>BufferNext<cr>"; key = "<A-l>"; }
      { mode = ["n" "i"]; action = "<cmd>BufferClose<cr>"; key = "<C-A-w>"; }

      # LSP
      { mode = "n"; action = "<cmd>lua vim.lsp.buf.definition()<cr>"; key = "<C-D>"; }
      { mode = "n"; action = "<cmd>lua vim.diagnostic.open_float()<cr>"; key = "<C-l>"; }
      { mode = "n"; action = "<cmd>lua vim.lsp.buf.rename()<cr>"; key="<F2>"; }
      { mode = "n"; action = "<cmd>lua vim.lsp.buf.hover()<cr>"; key="<leader>h"; }
      { mode = "n"; action = "<cmd>lua vim.diagnostic.open_float()<cr>"; key="<leader>D"; }

      # Rust
      { mode = "n"; action = "<cmd>lua vim.cmd.RustLsp('debuggables')<cr>"; key="<leader>Rd"; }
      { mode = "n"; action = "<cmd>lua vim.cmd.RustLsp{ 'hover', 'actions' }<cr>"; key="<leader>Rh"; }
      { mode = "n"; action = "<cmd>lua vim.cmd.RustLsp('codeAction')<cr>"; key="<leader>Ra"; }

      # Git
      { mode = "n"; action = "<cmd>DiffviewOpen<cr>"; key = "<F3>"; }
      { mode = "n"; action = "<cmd>DiffviewClose<cr>"; key = "<F4>"; }
      { mode = "n"; action = "<cmd>Flog<cr>"; key = "<F5>"; }

      # WhichKey
      { mode = "n"; action = "<cmd>WhichKey<cr>"; key = "<C-k>"; }

      # Misc
      { mode = "n"; action = "<cmd>lua require('whitespace-nvim').trim()<cr>"; key="<leader>tw"; }
    ];

    autoCmd = [{
      event = ["BufEnter" "CursorHold" "CursorHoldI" "FocusGained" ];
      pattern = [ "*" ];
      command = "if mode() != 'c' | checktime | endif";
    }];
  };

}