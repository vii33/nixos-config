# modules/home-manager/fish-shell.nix
{ config, pkgs, ... }:

{
  # Plugin settings ---------------------------------------------
  # Sponge: set false command purge after 5 commands
  home.file.".config/fish/conf.d/sponge.fish".text = ''
    # Configure fish sponge plugin delay
    set -U sponge_delay 5
  '';

  # Fish key bindings via Home Manager
  # Find out key codes with `fish_key_reader`
  programs.fish = {
    enable = true;
    functions.fish_user_key_bindings.body = ''
      # CTRL + U    whole line delete
      bind ctrl-u kill-whole-line
      bind -M insert ctrl--u kill-whole-line

      # CTRL + L   clear screen like bash
      bind \cl clear-screen

      # Ctrl+Right / Ctrl+Left for word-wise movement
      bind ctrl-right forward-word
      bind ctrl-left  backward-word
    '';
  };
}