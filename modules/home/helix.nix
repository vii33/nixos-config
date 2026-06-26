# ./modules/home/helix.nix
{ config, pkgs, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/repos/nixos-config/dotfiles";
in
{
  programs.helix = {
    enable = true;
    package = pkgs.helix;

    extraPackages = with pkgs; [
      # Language servers
      nil # Nix
      #rust-analyzer # Rust (commented; install via rustup)
    ];
  };

  xdg.configFile."helix/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/helix/config.toml";

  home.shellAliases.helix = "hx";
}
