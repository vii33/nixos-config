# modules/home/herdr.nix
# Herdr terminal multiplexer configuration
{
  config,
  pkgs,
  ...
}:
{
  home.file.".config/herdr/config.toml" = {
    force = true;
    text = ''
      # Managed by Home Manager (modules/home/herdr.nix)
      # See https://herdr.dev/docs/configuration/

      onboarding = false

      [terminal]
      # Herdr otherwise follows $SHELL and falls back to /bin/sh; pin Fish for panes.
      default_shell = "${pkgs.fish}/bin/fish"
      shell_mode = "auto"

      [keys]
      prefix = "f18"

      new_workspace = "prefix+n"
      next_workspace = "prefix+j"
      previous_workspace = "prefix+k"

      new_tab = "prefix+t"
      next_tab = "prefix+l"
      previous_tab = "prefix+h"
      switch_tab = ["prefix+1..9"]

      rename_tab = "prefix+r"
      rename_workspace = "prefix+shift+r"
      close_tab = ["prefix+shift+x"]
      close_workspace = ["prefix+d"]

      copy_mode = "prefix+c"
      resize_mode = "prefix+b"
      toggle_sidebar = "prefix+ctrl+b"
      goto = "prefix+g"

      focus_pane_left = "prefix+ctrl+h"
      focus_pane_down = "prefix+ctrl+j"
      focus_pane_up = "prefix+ctrl+k"
      focus_pane_right = "prefix+ctrl+l"

      cycle_pane_next = ["prefix+tab", "prefix+ä"]
      cycle_pane_previous = ["prefix+shift+tab", "prefix+ö"]
      next_agent = "prefix+ü"
      previous_agent = "prefix+p"

      split_vertical = "prefix+v"
      split_horizontal = "prefix+minus"

      reload_config = "prefix+ctrl+shift+r"
      open_notification_target = "prefix+o"

      [ui.toast]
      # delivery = "herdr"

      [ui.sound]
      enabled = false

      [experimental]
      pane_history = true

      [ui]
      show_agent_labels_on_pane_borders = true
      sidebar_width = 36
      sidebar_min_width = 23
      sidebar_max_width = 36
      confirm_close = true
      prompt_new_tab_name = true

      [session]
      resume_agents_on_restore = true

      [[keys.command]]
      key = "prefix+ctrl+g"
      type = "pane"
      command = "lazygit"
      description = "run lazygit"

      [[keys.command]]
      key = "prefix+0"
      type = "pane"
      command = "${config.home.homeDirectory}/repos/herdr-keybindings-tui/bin/keybindings-tui --data ${config.home.homeDirectory}/repos/herdr-keybindings-tui/keybindings.yaml"
      description = "show keybindings"
    '';
  };
}
