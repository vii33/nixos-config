# modules/home-manager/fish-shell.nix
{ config, pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  
  # Create a 'code' wrapper script for VS Code CLI
  vscode-cli = pkgs.writeShellScriptBin "code" ''
    open -a "Visual Studio Code" "$@"
  '';

  zellij-ccdr-finalize = pkgs.writeShellScriptBin "zellij-ccdr-finalize" ''
    set -eu

    if [ "$#" -ne 4 ]; then
      echo "usage: zellij-ccdr-finalize <session> <old-tab-id> <new-tab-id> <final-name>" >&2
      exit 2
    fi

    session_name="$1"
    old_tab_id="$2"
    new_tab_id="$3"
    final_name="$4"
    log_dir="$HOME/repos/nixos-config/.harness-logs"
    mkdir -p "$log_dir"
    log_file="$log_dir/zellij-ccdr-finalize-''${session_name}-''${old_tab_id}-''${new_tab_id}.log"

    log() {
      printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$log_file"
    }

    list_tabs_json() {
      zellij -s "$session_name" action list-tabs --json
    }

    dump_tabs() {
      log "tabs: $(list_tabs_json | tr '\n' ' ')"
    }

    tab_has_name() {
      local tab_id="$1"
      local expected_name="$2"
      list_tabs_json | python3 -c '
import json, sys
tab_id = int(sys.argv[1])
expected = sys.argv[2]
tabs = json.load(sys.stdin)
match = next((t for t in tabs if t["tab_id"] == tab_id), None)
raise SystemExit(0 if match and match["name"] == expected else 1)
' "$tab_id" "$expected_name"
    }

    tab_exists() {
      local tab_id="$1"
      list_tabs_json | python3 -c '
import json, sys
tab_id = int(sys.argv[1])
tabs = json.load(sys.stdin)
raise SystemExit(0 if any(t["tab_id"] == tab_id for t in tabs) else 1)
' "$tab_id"
    }

    log "start session=$session_name old_tab_id=$old_tab_id new_tab_id=$new_tab_id final_name=$final_name"
    dump_tabs

    log "rename-tab-by-id $new_tab_id $final_name"
    zellij -s "$session_name" action rename-tab-by-id "$new_tab_id" "$final_name"
    for _ in 1 2 3 4 5 6 7 8 9 10; do
      if tab_has_name "$new_tab_id" "$final_name"; then
        log "rename verified"
        break
      fi
      sleep 0.1
    done
    tab_has_name "$new_tab_id" "$final_name"
    dump_tabs

    log "close-tab-by-id $old_tab_id"
    zellij -s "$session_name" action close-tab-by-id "$old_tab_id"
    for _ in 1 2 3 4 5 6 7 8 9 10; do
      if ! tab_exists "$old_tab_id"; then
        log "close verified"
        dump_tabs
        exit 0
      fi
      sleep 0.1
    done

    dump_tabs
    echo "zellij-ccdr-finalize: old tab $old_tab_id still exists" >&2
    log "failure: old tab still exists"
    exit 1
  '';
in
{
  # Set environment variables for the session
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Add user and platform-specific binaries to PATH
  home.sessionPath = [
    "$HOME/.local/bin"
  ] ++ lib.optionals isDarwin [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/Applications/Ghostty.app/Contents/MacOS" # Ghostty CLI (e.g. `ghostty +list-themes`)
    "$HOME/.cargo/bin"
  ];

  # Enable zoxide (smart directory jumping) with fish integration
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  home.packages = with pkgs; [
    chafa                       # terminal image viewer (works on Linux & macOS)
    zellij-ccdr-finalize
  ] ++ lib.optionals isLinux [
    wl-clipboard                # for Wayland clipboard access (used by fun_copy_commandline_to_clipboard)
  ] ++ lib.optionals isDarwin [
    vscode-cli                  # 'code' command for opening VS Code
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

    # Fish plugins (must be declared here to be loaded properly)
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "plugin-sudope";
        src = pkgs.fishPlugins.plugin-sudope.src;
      }
      {
        name = "fzf-fish";
        src = (pkgs.fishPlugins.fzf-fish.overrideAttrs (oldAttrs: {
          doCheck = false;  # Skip tests due to missing fishtape dependency
        })).src;
      }
      {
        name = "colored-man-pages";
        src = pkgs.fishPlugins.colored-man-pages.src;
      }
    ];

    # Abbreviations
    shellAbbrs = {
      # Terminal
      tree = "eza --tree --level 2 --git-ignore";
      ezatree = "eza -T -a -L 2 --icons";
      ezal = "eza -lah --icons --git --group-directories-first --header";
      # Auto-run pane commands when resurrecting a session.
      zz = "zellij attach -c --forget main";
      zellijkill = "zellij kill-all-sessions -y; zellij delete-all-sessions -y";
      zzk = "zellij kill-all-sessions -y; zellij delete-all-sessions -y";
      
      # NixOS
      nodry = "nh os dry-run ~/nixos-config/flake.nix -H laptop";
      noswitch = "nh os switch ~/nixos-config/ -H laptop";
      noclean1 = "nh clean all --keep-since 3d --keep 3";
      noclean2 = "sudo nix-collect-garbage";
      nosearch = "nh search ";
      sopsedit = "env SOPS_AGE_KEY_FILE=\"$HOME/.config/sops/age/keys.txt\" nix shell nixpkgs#sops -c sops \"$HOME/repos/nixos-config/secrets/secrets.yaml\"";
      
      # Applications
      nv = "nvim";
      oc = "opencode";
      lg = "lazygit";
      cop = "copilot";
      coclaude = "copilot --model claude-sonnet-4.5";
      cocodex = "copilot --model gpt-5.3-codex";
      ocs = "if test -n \"$OPENCODE_SERVER_PASSWORD\"; opencode web --hostname 0.0.0.0 --port 8080; else; echo \"OPENCODE_SERVER_PASSWORD is not set\"; end";
      bs = "pybonsai -w 0.04";

      # Mac OS
      # Rebuild Home Manager, then detach and let a helper process remove the
      # current Zellij session so the next attach starts fresh.
      hmswitch =
        "home-manager switch --flake ~/repos/nixos-config/.#work --impure; and begin; "
        + "set -l session_name main; "
        + "if set -q ZELLIJ_SESSION_NAME; set session_name $ZELLIJ_SESSION_NAME; "
        + "nohup fish -c \"sleep 1; zellij kill-session '$session_name' >/dev/null 2>&1; "
        + "sleep 1; zellij delete-session '$session_name' >/dev/null 2>&1\" "
        + "</dev/null >/dev/null 2>&1 &; disown; zellij action detach; "
        + "else; zellij kill-session $session_name; sleep 1; "
        + "zellij delete-session $session_name; end; end";
      workswitch = "cd ~/repos/nixos-config; and darwin-rebuild build --flake .#work --impure; and sudo env \"PATH=$PATH\" ./result/activate";
      proxyrestart = "launchctl kickstart -k -p \"gui/$(id -u)/cc.colorto.proxydetox\"";

      # Kitty
      kittyreload = "kitty @ load-config";
    };

    shellAliases = {
      opensops = "env SOPS_AGE_KEY_FILE=\"$HOME/.config/sops/age/keys.txt\" nix shell nixpkgs#sops -c sops \"$HOME/repos/nixos-config/secrets/secrets.yaml\"";
    };

    # ShellInit use for fast and non-output things (e.g. path vars)
    shellInit = ''
      # (Interactive-only variables like fish_greeting & fish_escape_delay_ms moved to interactiveShellInit)
      if not contains -- "$HOME/.local/bin" $PATH
        set -gx PATH "$HOME/.local/bin" $PATH
      end
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

      # GitHub Copilot CLI aliases
      # ?? for what-the-shell, git? for git-assist, gh? for gh-assist
      if command -v github-copilot-cli >/dev/null 2>&1
        function __copilot_helper
          set TMPFILE (mktemp)
          set -l ret 0
          if github-copilot-cli $argv[1] $argv[2..-1] --shellout $TMPFILE
            if test -e "$TMPFILE"
              set FIXED_CMD (cat $TMPFILE)
              eval "$FIXED_CMD"
            else
              echo "Apologies! Extracting command failed"
            end
          else
            set ret 1
          end
          rm -f "$TMPFILE"
          return $ret
        end

        function ??
          __copilot_helper what-the-shell $argv
        end

        function git?
          __copilot_helper git-assist $argv
        end

        function gh?
          __copilot_helper gh-assist $argv
        end
      end
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
      bind ctrl-b fun_fzf_bindings
      bind -M insert ctrl-b fun_fzf_bindings
      bind -M visual ctrl-b fun_fzf_bindings

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

      # Ctrl+Shift+O -> fuzzy pick a file and insert (works in normal/insert/visual).
        bind ctrl-shift-o fun_fzf_file_open
        bind -M insert ctrl-shift-o fun_fzf_file_open
        bind -M visual ctrl-shift-o fun_fzf_file_open

      # Ctrl+E -> fuzzy pick an environment variable and insert "$VARNAME".
      bind ctrl-e fun_fzf_env_var_insert
      bind -M insert ctrl-e fun_fzf_env_var_insert
      bind -M visual ctrl-e fun_fzf_env_var_insert
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

    # Custom helper function: Ctrl+E launches an environment variable picker and inserts "$VARNAME".
    functions.fun_fzf_env_var_insert.body = ''
      if not type -q fzf
        echo "fzf not found in PATH (required for fun_fzf_env_var_insert)" >&2
        return 127
      end

      if not type -q printenv
        echo "printenv not found in PATH (required for fun_fzf_env_var_insert)" >&2
        return 127
      end

      set -l var_name (command env | string replace -r '=.*' "" | sort -u | fzf \
        --prompt="env> " \
        --height=60% \
        --reverse \
        --border \
        --exit-0 \
        --preview 'printenv {} 2>/dev/null | head -c 2000' \
        --preview-window=right,60%:wrap )

      test -n "$var_name"; or return 0

      commandline -i "\$$var_name"
      commandline -f repaint
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

    # Custom helper function: Ctrl+Shift+O launches a file picker and inserts the selected file path at cursor.
    # - Uses fd if available (respects .gitignore); falls back to find.
    # - Shows preview with bat for text files and chafa for images.
    # - Future idea: launch nvim when no editor was given in command
    functions.fun_fzf_file_open.body = ''
      # Build file list command (fd preferred)
      # Exclude heavy/generated dirs for snappy startup
      set -l list_cmd ""
      if type -q fd
        set list_cmd "fd --type f --hidden --follow \
          --exclude .git \
          --exclude node_modules \
          --exclude .direnv \
          --exclude result \
          --exclude .cache \
          --exclude __pycache__ \
          --exclude .venv \
          --exclude venv \
          --exclude target \
          --exclude .next \
          --exclude dist \
          --exclude build \
          --exclude .nix-defexpr"
      else
        set list_cmd "find . -type f \
          -not -path '*/.git/*' \
          -not -path '*/node_modules/*' \
          -not -path '*/.direnv/*' \
          -not -path '*/result/*' \
          -not -path '*/.cache/*' \
          -not -path '*/__pycache__/*' \
          -not -path '*/.venv/*' \
          -not -path '*/venv/*' \
          -not -path '*/target/*' \
          -not -path '*/.next/*' \
          -not -path '*/dist/*' \
          -not -path '*/build/*' \
          -not -path '*/.nix-defexpr/*'"
      end

      # Invoke picker with smart preview (images via chafa, text via bat)
      set -l file (eval $list_cmd | fzf \
        --prompt="file> " \
        --height=80% \
        --reverse \
        --border \
        --preview 'if file --mime-type {} | grep -qE "image/(png|jpeg|jpg|gif|bmp|webp|svg)"; then
            chafa --size="$FZF_PREVIEW_COLUMNS"x"$FZF_PREVIEW_LINES" --animate=false {} 2>/dev/null;
          else
            bat --style=numbers --color=always --line-range=:300 {} 2>/dev/null;
          fi' \
        --preview-window=right,50%:wrap )

      test -n "$file"; or return 0

      # Always properly escape the path (handles spaces and special chars)
      set -l insert_path (string escape -- "$file")
      commandline -i $insert_path
      commandline -f repaint
    '';

    # Zellij: switch all panes in current oc tab to a new directory.
    # Run from a floating pane: opens an fzf directory picker, then
    # restarts the current oc layout (opencode, attach, yazi) in that folder.
    functions.ccd.body = ''
      # ── 0. Guard: only run on oc tabs ──────────────────────────────
      set -l current_tab (zellij action dump-layout 2>/dev/null \
        | string match -r 'tab name="[^"]*" focus=true' \
        | tail -1 \
        | string replace -r '.*tab name="([^"]*)" focus=true.*' '$1')
      if not string match -q 'oc*' "$current_tab"
        echo "ccd: only works on oc tabs (current: $current_tab)"
        sleep 2
        return 1
      end

      # ── 1. Pick a directory with fzf ──────────────────────────────
      set -l fd_cmd "fd --type d --max-depth 3 --no-ignore-vcs --exclude node_modules --exclude .cache --exclude __pycache__ --exclude .venv --exclude target --exclude Library --exclude .Trash --exclude .npm --exclude .bun -- . $HOME $HOME/Library/CloudStorage"

      set -l target (eval $fd_cmd | fzf \
        --prompt="Choose Directory> " \
        --height=80% \
        --reverse \
        --border \
        --exit-0 \
        --preview 'ls -1 {} 2>/dev/null | head -60' \
        --preview-window=right,40%:wrap )

      test -n "$target"; or return 0
      set -l target_dir (realpath "$target")
      set -l target_dir_escaped (string escape -- "$target_dir")

      if not test -d "$target_dir"
        echo "Error: $target_dir is not a directory"
        return 1
      end

      echo "Switching workspace → $target_dir"

      # ── 2. Hide floating pane → focus moves to tiled layer ────────
      zellij action toggle-floating-panes
      sleep 0.3

      # ── 3. OpenCode pane (left) ───────────────────────────────────
      zellij action move-focus "Left"
      sleep 0.15
      # Ctrl+C twice to quit opencode (or harmless at shell prompt)
      zellij action write 3
      sleep 0.3
      zellij action write 3
      sleep 0.5
      # Clear any leftover text (Ctrl+U) then cd + restart
      zellij action write 21
      sleep 0.1
      zellij action write-chars "cd $target_dir_escaped; opencode"
      zellij action write 13

      # ── 4. Attach pane (top-right) ────────────────────────────────
      sleep 0.3
      zellij action move-focus "Right"
      sleep 0.15
      zellij action move-focus "Up"
      sleep 0.15
      # Ctrl+C twice to quit attach (or harmless at shell prompt)
      zellij action write 3
      sleep 0.3
      zellij action write 3
      sleep 0.5
      # Clear line, then reattach with the selected remote working directory.
      zellij action write 21
      sleep 0.1
      zellij action write-chars "cd $target_dir_escaped; sleep 4; opencode attach http://localhost:4096 --dir $target_dir_escaped"
      zellij action write 13

      # ── 5. Yazi pane (bottom-right) ───────────────────────────────
      sleep 0.3
      zellij action move-focus "Down"
      sleep 0.15
      # q quits yazi (harmless at shell — just types "q" + enter not sent)
      zellij action write-chars "q"
      sleep 0.5
      # Clear line, cd + restart
      zellij action write 21
      sleep 0.1
      zellij action write-chars "cd $target_dir_escaped; yazi"
      zellij action write 13
    '';

    # Zellij: safely rebuild the current oc tab in a new directory.
    # Unlike ccd, this does not send control keys into running TUIs.
    # Requires Zellij >= 0.44 for stable tab-id actions.
    functions.ccdr.body = ''
      set -l log_dir "$HOME/repos/nixos-config/.harness-logs"
      mkdir -p "$log_dir"
      set -l run_id (date +%Y%m%d-%H%M%S)-$fish_pid
      set -l log_file "$log_dir/ccdr-$run_id.log"

      function _ccdr_log
        printf '[%s] %s\n' (date '+%Y-%m-%d %H:%M:%S') "$argv" >> "$log_file"
      end

      set -l current_tab ""
      set -l current_tab_id ""
      set -l current_position ""
      set -l tab_count (count (zellij action query-tab-names 2>/dev/null))
      set -l tab_info_json (zellij action current-tab-info --json 2>/dev/null)
      set -l tab_info (printf '%s\n' "$tab_info_json" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["name"]); print(d["tab_id"]); print(d["position"])')

      if test (count $tab_info) -ge 3
        set current_tab $tab_info[1]
        set current_tab_id $tab_info[2]
        set current_position $tab_info[3]
      end

      _ccdr_log "start run_id=$run_id"
      _ccdr_log "tab_info_json=$tab_info_json"
      _ccdr_log "current_tab=$current_tab current_tab_id=$current_tab_id current_position=$current_position tab_count=$tab_count"
      _ccdr_log "tabs_before="(zellij action list-tabs --json 2>/dev/null | string collect)

      if test -z "$current_tab"; or test -z "$current_tab_id"; or test -z "$current_position"
        _ccdr_log "error: could not determine current tab info"
        echo "ccdr: could not determine current tab info"
        return 1
      end

      if not string match -q 'oc*' "$current_tab"
        _ccdr_log "error: current tab not oc* ($current_tab)"
        echo "ccdr: only works on oc tabs (current: $current_tab)"
        sleep 2
        return 1
      end

      if not set -q ZELLIJ_SESSION_NAME
        _ccdr_log "error: missing ZELLIJ_SESSION_NAME"
        echo "ccdr: missing ZELLIJ_SESSION_NAME"
        return 1
      end

      set -l fd_cmd "fd --type d --max-depth 3 --no-ignore-vcs --exclude node_modules --exclude .cache --exclude __pycache__ --exclude .venv --exclude target --exclude Library --exclude .Trash --exclude .npm --exclude .bun -- . $HOME $HOME/Library/CloudStorage"

      set -l target (eval $fd_cmd | fzf \
        --prompt="Choose Directory> " \
        --height=80% \
        --reverse \
        --border \
        --exit-0 \
        --preview 'ls -1 {} 2>/dev/null | head -60' \
        --preview-window=right,40%:wrap )

      test -n "$target"; or return 0
      set -l target_dir (realpath "$target")
      _ccdr_log "target=$target target_dir=$target_dir"

      if not test -d "$target_dir"
        _ccdr_log "error: target is not a directory"
        echo "Error: $target_dir is not a directory"
        return 1
      end

      set -l layout_path "$HOME/.config/zellij/layouts/oc-tab.kdl"
      if not test -f "$layout_path"
        _ccdr_log "error: missing layout $layout_path"
        echo "ccdr: missing layout $layout_path"
        return 1
      end

      set -l temp_tab_name "$current_tab-reload-"(random)
      set -l moves_left (math "$tab_count - $current_position - 1")
      _ccdr_log "temp_tab_name=$temp_tab_name moves_left=$moves_left layout_path=$layout_path session=$ZELLIJ_SESSION_NAME"

      zellij action hide-floating-panes --tab-id "$current_tab_id" >/dev/null 2>&1
      _ccdr_log "hide-floating-panes tab_id=$current_tab_id"
      sleep 0.2

      # One visible switch: the new tab is created focused, then moved by stable
      # tab-id into the original slot. The old tab is closed by id, so there is
      # no need to switch back to it.
      set -l new_tab_id (zellij action new-tab --layout "$layout_path" --cwd "$target_dir" --name "$temp_tab_name")
      _ccdr_log "new_tab_id=$new_tab_id"
      if test -z "$new_tab_id"
        _ccdr_log "error: failed to create replacement tab"
        echo "ccdr: failed to create replacement tab"
        return 1
      end

      _ccdr_log "tabs_after_new_tab="(zellij action list-tabs --json 2>/dev/null | string collect)

      sleep 0.3
      while test $moves_left -gt 0
        _ccdr_log "move-tab left new_tab_id=$new_tab_id remaining=$moves_left"
        zellij action move-tab --tab-id "$new_tab_id" left
        sleep 0.1
        set moves_left (math "$moves_left - 1")
      end

      _ccdr_log "tabs_after_reorder="(zellij action list-tabs --json 2>/dev/null | string collect)

      # We are still running inside a floating pane on the old tab. Closing that
      # tab would kill this process before the rename happens, so the final steps
      # must run from a detached helper against the session by stable tab IDs.
      # Keep the helper/file logging for now even though the UI debug text is
      # gone; it gives us post-mortem evidence if Alt+C regresses again.
      set -l session_name "$ZELLIJ_SESSION_NAME"
      _ccdr_log "launch_helper session=$session_name old_tab_id=$current_tab_id new_tab_id=$new_tab_id final_name=$current_tab"
      nohup zellij-ccdr-finalize "$session_name" "$current_tab_id" "$new_tab_id" "$current_tab" </dev/null >/dev/null 2>&1 &
      disown
      _ccdr_log "helper_launched"
    '';
  };
}
