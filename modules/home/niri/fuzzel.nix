# modules/home/niri/fuzzel.nix
# Fuzzel application launcher for Wayland
{ config, pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
        font = "JetBrainsMono Nerd Font:size=10";
        dpi-aware = "no";
        show-actions = "yes";
        width = 50;
        lines = 15;
        horizontal-pad = 20;
        vertical-pad = 10;
        inner-pad = 5;
      };

      colors = {
        background = "282a36dd";
        text = "f8f8f2ff";
        match = "8be9fdff";
        selection = "44475add";
        selection-text = "f8f8f2ff";
        selection-match = "8be9fdff";
        border = "bd93f9ff";
      };

      border = {
        width = 2;
        radius = 8;
      };
    };
  };
}
