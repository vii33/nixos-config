# modules/home-manager/fish-shell.nix
{ config, pkgs, lib, ... }:

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
    plugins = [
      { name = "transient-fish"; src = pkgs.fishPlugins.transient-fish; }
      { name = "tide"; src = pkgs.fishPlugins.tide; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge; }
      { name = "sudope"; src = pkgs.fishPlugins.plugin-sudope; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish; }
      { name = "hydro"; src = pkgs.fishPlugins.hydro; }
    ];
    shellInit = ''
      # Set ESC key delay to 500 ms so SUDOPE plugins works better (TODO doesn't work still))
      set -g fish_escape_delay_ms 500
      # Set alternative keybinding for sudope  (ALT+S)
      set -g sudope_sequence \es

      set -g fish_greeting "🦤🦤🪴"
    '';
    interactiveShellInit = ''
      # Set up Tide 
      # Only run if Tide hasn't been configured yet on this machine
      if not set -q tide_prompt_transient_enabled
        tide configure --auto \
          --style=Rainbow \
          --prompt_colors='True color' \
          --show_time=No \
          --rainbow_prompt_separators=Slanted \
          --powerline_prompt_heads=Slanted \
          --powerline_prompt_tails=Flat \
          --powerline_prompt_style='Two lines, character' \
          --prompt_connection=Dotted \
          --powerline_right_prompt_frame=No \
          --prompt_connection_andor_frame_color=Dark \
          --prompt_spacing=Sparse \
          --icons='Many icons' \
          --transient=Yes
      end
    '';
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