# modules/home-manager/fish-shell.nix
{ config, pkgs, lib, ... }:

{
  # Enable zoxide (smart directory jumping) with fish integration
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  home.packages = with pkgs; [
    #fishPlugins.transient-fish
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

    # 
    shellAbbrs = {
      nv = "nvim";
      nbl = "sudo nixos-rebuild switch --flake ~/nixos-config/.#laptop"
    };

    shellInit = ''
      # Set ESC key delay to 500 ms so SUDOPE plugins works better (TODO doesn't work still))
      set -g fish_escape_delay_ms 500
      # Set alternative keybinding for sudope  (ALT+S)
      set -g sudope_sequence \es

      set -g fish_greeting "🦤 🦤 🪴"


      # FZF: Apply vim-style movement keys globally to all fzf instances
      # Using array form so each option is its own argument (clearer & avoids long quoted string)
      # Reference: https://github.com/junegunn/fzf
      # Further keybinding (use different keys, currently conflicting with fish bindings): 
        #--bind=ctrl-u:half-page-up \
        #--bind=ctrl-d:half-page-down \
        #--bind=ctrl-f:page-down \
        #--bind=ctrl-b:page-up \
      set -gx FZF_DEFAULT_OPTS \
        --bind=ctrl-j:down \
        --bind=ctrl-k:up \
        --bind=enter:accept

      # Reuse same bindings for completion integrations (fzf.fish, etc.)
      set -gx FZF_COMPLETE_OPTS $FZF_DEFAULT_OPTS
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

      # Extra readability between commands when using tide's transient prompt:
      # The transient prompt collapses previous prompts, making it harder to visually
      # separate one finished command from the start of the next. This postexec hook
      # prints a blank line right before the next prompt.
      # (Placed here instead of redefining fish_prompt to avoid conflicts with tide updates.)
        #if not functions -q __postexec_blankline
        #  function __postexec_blankline --on-event fish_postexec
        #    printf '🦉\n'
        #  end
        #end
    '';

    # Custom key bindings
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