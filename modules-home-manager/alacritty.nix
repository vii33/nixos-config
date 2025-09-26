# ./modules/home-manager/alacritty.nix
# Alacritty depends on Fish shell and MesloLG Nerd font
{ config, pkgs, ... }:

{
programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = { x = 8; y = 8; };
        #opacity = 0.95;
        dimensions = {
          columns = 112;  # 40% larger than typical 80 column default
          lines = 34;     # 40% larger than typical 24 line default
        };
      };
      # Different font: install via ./modules/default.nix. Check with 'fc-list : family | grep -i xxxxx'
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
      colors = {  # Dracula
        primary = {
          background = "0x20222b";
          foreground = "0xf8f8f2";
        };
        normal = {
          black   = "0x21222c";
          red     = "0xff5555";
          green   = "0x50fa7b";
          yellow  = "0xf1fa8c";
          blue    = "0xbd93f9";
          magenta = "0xff79c6";
          cyan    = "0x8be9fd";
          white   = "0xf8f8f2";
        };
        bright = {
          black   = "0x6272a4";
          red     = "0xff6e6e";
          green   = "0x69ff94";
          yellow  = "0xffffa5";
          blue    = "0xd6acff";
          magenta = "0xff92df";
          cyan    = "0xa4ffff";
          white   = "0xffffff";
        };
      };
    };
  };
}