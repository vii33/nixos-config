# modules/home-manager/fish-shell.nix
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    fishPlugins.transient-fish
    fishPlugins.tide            # styling
    fishPlugins.sponge          # remove wrong commands from history
    fishPlugins.plugin-sudope   # insert sudo with alt+s
    fishPlugins.fzf-fish
    # fishPlugins.hydro         # removed due to fish_prompt.fish filename collision with tide
    fishPlugins.colored-man-pages
  ];

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

    shellInit = ''
      # Set ESC key delay to 500 ms so SUDOPE plugins works better (TODO doesn't work still))
      set -g fish_escape_delay_ms 500
      # Set alternative keybinding for sudope  (ALT+S)
      set -g sudope_sequence \es

      set -g fish_greeting "🦤 🦤 🪴"
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
      bind ctrl-l clear-screen

      # Ctrl+Right / Ctrl+Left for word-wise movement
      bind ctrl-right forward-word
      bind ctrl-left  backward-word

      # Ctrl+B -> fuzzy search existing fish key bindings (overrides default backward-char)
      bind ctrl-b fzf_bindings   # custom function defined below

      # Change fzf.fish keybindings (fzf_configure_bindings needs to be called at least to get default bindings)
      # help:   fzf_configure_bindings --h
      if functions -q fzf_configure_bindings
        fzf_configure_bindings --processes=ctrl-p --directory=ctrl-f
      end
    '';

    # Custom helper function: fzf_bindings
    functions.fzf_bindings.body = ''
      # Fuzzy search current fish key bindings using fzf
      if not type -q fzf
        echo "fzf not found in PATH (required for fzf_bindings)" >&2
        return 127
      end

      # Collect bindings, strip leading 'bind ' and let user pick
      set -l selection (bind | sed 's/^bind \\+//' | fzf \
        --prompt="fish bindings> " \
        --height=60% \
        --reverse \
        --border \
        --exit-0 \
        --preview 'echo {}' )

      if test -n "$selection"
        set_color --bold green
        echo Selected binding:
        set_color normal
        echo "$selection"
        # Optionally: parse key + command
        # echo "$selection" | read -l key rest; echo "Key: $key"; echo "Command: $rest"
      end
    '';
  };
}