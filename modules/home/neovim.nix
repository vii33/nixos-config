{ config, pkgs, lib, ... }:

{
  programs.neovim.enable = true;

  # tools LazyVim expects
  home.packages = with pkgs; [
    git ripgrep fd gcc gnumake unzip
    # choose one of these for clipboard:
    #xclip              # X11
    wl-clipboard     # Wayland
  ];

  # Symlink your repo into ~/.config/nvim
  xdg.configFile."nvim".source =
   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/neovim-config";
}