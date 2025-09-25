# Alacritty depends on Fish shell and MesloLG Nerd font
# ./modules/home-manager/alacritty.nix
{ config, pkgs, ... }:

{
programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = { x = 8; y = 8; };
        #opacity = 0.95;
      };
      font = {
        normal = {
          family = "MesloLGS Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "MesloLGS Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "MesloLGS Nerd Font Mono";
          style = "Italic";
        };
        size = 11.0;
      };
      terminal.shell = {
        program = "${pkgs.fish}/bin/fish";
      };
      colors = {
        primary = {
          background = "0x1e1e2e";
          foreground = "0xcdd6f4";
        };
        normal = {
          black   = "0x45475a";
          red     = "0xf38ba8";
          green   = "0xa6e3a1";
          yellow  = "0xf9e2af";
          blue    = "0x89b4fa";
          magenta = "0xf5c2e7";
          cyan    = "0x94e2d5";
          white   = "0xbac2de";
        };
      };
    };
  };
}