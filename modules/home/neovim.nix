{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    
    # Install treesitter parsers at the system level to avoid conflicts
    extraPackages = with pkgs; [
      tree-sitter
    ];
  };

  # Tools LazyVim expects
  home.packages = with pkgs; [
    git ripgrep fd gcc gnumake unzip
    # choose one of these for clipboard:
    #xclip              # X11
    wl-clipboard     # Wayland
    
    # Additional tools for better LazyVim experience
    nodejs_20        # Required for many LSP servers
    # Python3 already included in other config
  ];

  # Symlink to my neovim config ~/.config/nvim
  xdg.configFile."nvim".source =
   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/neovim-config";
}