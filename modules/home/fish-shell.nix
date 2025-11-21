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
    wl-clipboard                # for Wayland clipboard access (used by fun_copy_commandline_to_clipboard)
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

    # Abbreviations
    shellAbbrs = {
      nv = "nvim";
      nodry = "nh os dry-run --flake .#laptop";
      noswitch = "nh os switch --flake .#laptop";
      noclean = "nh clean all --keep-since 3d --keep 3";
      nosearch = "nh search ";
    };

    # ShellInit use for fast and non-output things (e.g. path vars)
    shellInit = ''
      # (Interactive-only variables like fish_greeting & fish_escape_delay_ms moved to interactiveShellInit)
    '';

    interactiveShellInit = ''
      # Enable vi-style key bindings (I think the overwrite all other key bindings) 
      fish_vi_key_bindings           # possible to start in different vim mode

      # Greeting (random greeting see https://fishshell.com/docs/current/interactive.html#interactive)
      set -g fish_greeting "🦤 🦤 🪴"

      # ESC key delay tweak (only matters with human input & vi bindings)
      set -g fish_escape_delay_ms 500
      
      # Alternative keybinding sequence for sudope plugin (ALT+S)
      set -g sudope_sequence \es

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

      # FZF: Apply vim-style movement keys globally to all fzf instances
      # Using array form so each option is its own argument (clearer & avoids long quoted string)
      # Reference: https://github.com/junegunn/fzf
      # Further keybinding (use different keys, currently conflicting with fish bindings): 
        #--bind=ctrl-f:page-down \
        #--bind=ctrl-b:page-up \
      set -gx FZF_DEFAULT_OPTS \
        --bind=ctrl-j:down \
        --bind=ctrl-k:up \
        --bind=ctrl-d:half-page-down \
        --bind=ctrl-u:half-page-up \
        --bind=enter:accept

      # Reuse same bindings for completion integrations (fzf.fish, etc.)
      set -gx FZF_COMPLETE_OPTS $FZF_DEFAULT_OPTS

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
      # Remove ctrl-w to allow Neovim window cycling in terminal buffers
      bind --erase ctrl-w

      # CTRL + L    whole line delete
      bind ctrl-l kill-whole-line
      bind -M insert ctrl--l kill-whole-line

      # CTRL + S   clear screen 
      bind ctrl-s clear-screen

      # Ctrl+Right / Ctrl+Left for word-wise movement
      bind ctrl-right forward-word
      bind ctrl-left  backward-word

      # Ctrl+B -> fuzzy search existing fish key bindings (overrides default backward-char)
      bind ctrl-b fun_fzf_bindings   # custom function defined below

      # Change fzf.fish keybindings (fzf_configure_bindings needs to be called at least to get default bindings)
      # help:   fzf_configure_bindings --h
      if functions -q fzf_configure_bindings
        fzf_configure_bindings --processes=ctrl-p --directory=ctrl-f
      end

      # Copy current command line to clipboard
      # Ctrl+Y in insert mode
      bind -M insert ctrl-y fun_copy_commandline_to_clipboard
      # Vim-like yy in normal (default) mode
      bind -M default 'yy' 'fun_copy_commandline_to_clipboard'

      # Ctrl+O -> fuzzy pick a file and insert (works in normal/insert/visual).
        bind ctrl-o fun_fzf_file_open
        bind -M insert ctrl-o fun_fzf_file_open
        bind -M visual ctrl-o fun_fzf_file_open
        '';

    # Custom helper function: fzf_bindings
    functions.fun_fzf_bindings.body = ''
      # Fuzzy search current fish key bindings using fzf
      if not type -q fzf
        echo "fzf not found in PATH (required for fun_fzf_bindings)" >&2
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

    # Custom helper function: copy current command line buffer to the clipboard (Wayland/X11/macOS)
    functions.fun_copy_commandline_to_clipboard.body = ''
      set -l line (commandline)
      if test -z "$line"
        return 0
      end

      if type -q wl-copy
        printf '%s' "$line" | wl-copy
      else if type -q xclip
        printf '%s' "$line" | xclip -selection clipboard
      else if type -q xsel
        printf '%s' "$line" | xsel --clipboard --input
      else if type -q pbcopy
        printf '%s' "$line" | pbcopy
      else
        printf 'No clipboard tool (wl-copy/xclip/xsel/pbcopy) found\n' >&2
        return 1
      end
    '';

    # Custom helper function: Ctrl+O launches a file picker and inserts the selected file path at cursor.
    # - Uses fd if available (respects .gitignore); falls back to find.
    # - Shows preview with bat (if installed) limited to first 300 lines.
    # - Future idea: launch nvim when no editor was given in command
    functions.fun_fzf_file_open.body = ''
      # Build file list command (fd preferred)
      set -l list_cmd ""
      if type -q fd
        set list_cmd "fd --type f --hidden --follow --exclude .git"
      else
        set list_cmd "find . -type f -not -path '*/.git/*'"
      end

      # Invoke picker
      set -l file (eval $list_cmd | fzf \
        --prompt="file> " \
        --height=80% \
        --reverse \
        --border \
        --preview 'bat --style=numbers --color=always --line-range=:300 {} 2>/dev/null' \
        --preview-window=right,50%:wrap )

      test -n "$file"; or return 0

      # Always properly escape the path (handles spaces and special chars)
      set -l insert_path (string escape -- "$file")
      commandline -i $insert_path
      commandline -f repaint
    '';
  };
}