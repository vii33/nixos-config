{ config, pkgs, lib, ... }:

let
  inherit (lib.nixvim) mkRaw;
in
{
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

    opts = {
      number          = true;
      relativenumber  = true;
      tabstop	        = 2;
      softtabstop = 2;
      undofile = true;
      autowrite = true; # Enable auto write
      autoread = true; # Auto read file when changed outside of nvim
      clipboard = "unnamedplus";  # Sync with system clipboard 
      completeopt = "menu,menuone,noselect";
      conceallevel = 2; # Hide * markup for bold and italic, but not markers with substitutions
      confirm = true; # Confirm to save changes before exiting modified buffer
      cursorline = true; # Enable highlighting of the current line
      expandtab = true; # Use spaces instead of tabs
      fillchars = {
        foldopen = "";
        foldclose = "";
        fold = " ";
        foldsep = " ";
        diff = "╱";
        eob = " ";
      };
      fileencoding = "utf-8";
      foldlevel = 99;
      foldmethod = "indent";
      foldtext = "";
      # formatexpr = "v:lua.LazyVim.format.formatexpr()"; # LazyVim specific, not applicable in nixvim
      formatoptions = "jcroqlnt"; # tcqj
      grepformat = "%f:%l:%c:%m";
      grepprg = "rg --vimgrep";
      ignorecase = true; # Ignore case
      inccommand = "nosplit"; # preview incremental substitute
      jumpoptions = "view";
      laststatus = 3; # global statusline
      linebreak = true; # Wrap lines at convenient points
      list = true; # Show some invisible characters (tabs...
      mouse = "a"; # Enable mouse mode

      pumblend = 10; # Popup blend
      pumheight = 10; # Maximum number of entries in a popup

      ruler = false; # Disable the default ruler
      scrolloff = 4; # Lines of context
      sessionoptions = [ "buffers" "curdir" "tabpages" "winsize" "help" "globals" "skiprtp" "folds" ];
      shiftround = true; # Round indent
      shiftwidth = 2; # Size of an indent
      # shortmess:append({ W = true, I = true, c = true, C = true }); # Lua method call, not supported in nixvim opts
      showmode = false; # Dont show mode since we have a statusline
      sidescrolloff = 8; # Columns of context
      signcolumn = "yes"; # Always show the signcolumn, otherwise it would shift the text each time
      smartcase = true; # Don't ignore case with capitals
      smartindent = true; # Insert indents automatically
      smoothscroll = true;
      spelllang = [ "en" ];
      splitbelow = true; # Put new windows below current
      splitkeep = "screen";
      splitright = true; # Put new windows right of current
      # statuscolumn = [[%!v:lua.LazyVim.statuscolumn()]]; # LazyVim specific, not applicable in nixvim
     
      termguicolors = true; # True color support
      # timeoutlen = vim.g.vscode and 1000 or 300; # Conditional assignment not supported in nixvim opts
      timeoutlen = 300; # Lower than default (1000) to quickly trigger which-key
    
      undolevels = 10000;
      updatetime = 500; # Save swap file and trigger CursorHold
      virtualedit = "block"; # Allow cursor to move where there is no text in visual block mode
      wildmode = "longest:full,full"; # Command-line completion mode
      winminwidth = 5; # Minimum window width
      wrap = false; # Disable line wrap
    };

    autoCmd = [
    {
      desc = "Highlight on yank";
      event = [ "TextYankPost" ];
      callback =
        # lua
        mkRaw ''
          function()
            vim.highlight.on_yank()
          end
        '';
    }
    {
      desc = "Check file changes";
      event = [
        "FocusGained"
        "BufEnter"
        "CursorHold"
      ];
      pattern = [ "*" ];
      callback =
        # lua
        mkRaw ''
          function()
            if vim.fn.mode() ~= "c" then
              vim.cmd("checktime")
            end
          end
        '';
    }
    ];

    extraLuaPackages = lp: with lp; [ luarocks ];
    # Extra binaries used by LSP / tooling that aren't auto-provided
    extraPackages = with pkgs; [
      nodePackages.yaml-language-server         # YAML LS (yamlls)
      nodePackages.vscode-json-languageserver   # JSON LS (jsonls)
      ruff                                      # Python linter / formatter (fixes)
      black                                     # Python formatter
      nodePackages.prettier                     # Prettier for JS/TS/JSON/Markdown/YAML
    ];

    plugins = {
      # Core/navigation/UI
      barbar.enable               = true;  # Buffer tabs
      telescope.enable            = true;  # Fuzzy finder
      treesitter.enable           = true;  # Syntax & parsing
      indent-blankline.enable     = true;  # Indent guides
      toggleterm.enable           = true;  # Integrated terminal
      web-devicons.enable         = true;  # Icons
      which-key.enable            = true;  # Keybinding helper
      notify.enable               = true;  # Notification backend
      noice.enable                = true;  # Enhanced UI (cmdline/messages)
      rainbow-delimiters.enable   = true;  # Rainbow parentheses
      whitespace.enable           = true;  # Trailing space highlight

      # Statuslines / UI bars
      lualine.enable              = true;

      # Git / Diff / Versioning
      gitsigns.enable             = true;
      diffview.enable             = true;
      fugitive.enable             = true;

      # LSP / Dev tooling
      lsp.enable                    = true;
      # LSP servers
      # Explicitly declare dockerls to stop nixvim from attempting to use a non-existent
      # pkgs.dockerfile-language-server (some nixvim versions assume that attr name).
      # We keep it disabled for now but provide the correct package mapping.
       lsp.servers.dockerls = {
         enable = false;
         package = pkgs.dockerfile-language-server-nodejs;
       };
      lsp.servers.yamlls.enable     = true;  # YAML
      lsp.servers.jsonls.enable     = true;  # JSON
      # Python (Ruff for linting/formatting; no full type-checking like Pyright)
      lsp.servers.ruff.enable       = true;  # Python via ruff LSP

      blink-cmp.enable            = true;  # Completion engine (replaces nvim-cmp stack)
      markview.enable             = true;  # Markdown preview/enhancements
      neotest.enable              = true;  # Testing

      # Debugging
      dap.enable                  = true;  # Core DAP (UI/virtual text via extraPlugins for now)

      # Troubleshooting / UX
      trouble.enable              = true;
    };

    # Example plugin-specific settings (still valid since plugins attrset retained)
    plugins.barbar.settings.animation = true;

    # Plugins not (yet) provided by nixvim modules or needing custom sourcing
    extraPlugins = with pkgs.vimPlugins; [
      # Syntax / git helpers
      vim-hcl                # HashiCorp Configuration Language syntax
      vim-flog               # Git branch visualization
      # Removed vim-gitbranch and vim-airline-themes after dropping airline

      # Extended UI / utility (no nixvim module yet)
      snacks-nvim            # Multi-feature enhancement pack
      neoconf-nvim           # Project-level Neovim config discovery
      #nvim-treesitter-playground  # Treesitter query playground

      # DAP extensions (enable via nixvim modules if/when available; keep raw otherwise)
      nvim-dap-ui
      nvim-dap-virtual-text

      # Mini.nvim (load once; configure submodules in extraConfigLua)
      mini-nvim  
    ];

  };

  # Configure Lua-side setup for mini.nvim modules that we actually use
  programs.nixvim.extraConfigLua = ''
    -- Mini.nvim module setups (only enable what you need)
    pcall(function() require('mini.ai').setup() end)
    pcall(function() require('mini.pairs').setup() end)
    pcall(function() require('mini.surround').setup() end)
    -- mini.icons: provide icons; safest to call empty setup if present
    pcall(function() require('mini.icons').setup() end)
  '';



  # # Tools LazyVim expects
  # home.packages = with pkgs; [
  #   git ripgrep fd gcc gnumake unzip wget curl
  #   # choose one of these for clipboard:
  #   #xclip              # X11
  #   wl-clipboard     # Wayland
    
  #   # Additional tools for better LazyVim experience
  #   nodejs_24        # Required for many LSP servers
  #   # Python3 already included in other config
  #   # LSP servers and formatters
  #   nixd          # For nix-lsp
  #   lua-language-server 
  #   marksman 
  #   stylua
  # ];


}