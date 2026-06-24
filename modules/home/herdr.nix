# modules/home/herdr.nix
# Herdr terminal multiplexer configuration
{
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

      [keys]
      prefix = "f15"

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
      agent_panel_scope = "all"
      show_agent_labels_on_pane_borders = true
      sidebar_width = 36
      sidebar_min_width = 23
      sidebar_max_width = 36
      confirm_close = false
      prompt_new_tab_name = true

      [session]
      resume_agents_on_restore = true

      [[keys.command]]
      key = "prefix+ctrl+g"
      type = "pane"
      command = "lazygit"
      description = "run lazygit"
    '';
  };
}
