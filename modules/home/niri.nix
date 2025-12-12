# modules/home/niri.nix
# Home Manager configuration for niri Wayland compositor
{ config, pkgs, lib, ... }:

{
  programs.niri = {
    settings = {
      # Environment variables
      environment = {
        NIXOS_OZONE_WL = "1";  # Enable Wayland for Electron apps
      };

      # Spawn commands at startup
      spawn-at-startup = [
        # Reset waybar service to work around systemd restart limits
        { command = [ "systemctl" "--user" "reset-failed" "waybar.service" ]; }
        { command = [ "systemctl" "--user" "start" "waybar.service" ]; }
      ];

      # Input configuration
      input = {
        keyboard = {
          xkb = {
            layout = "de";
          };
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
        };
        mouse = {
          natural-scroll = false;
        };
      };

      # Layout configuration
      layout = {
        gaps = 8;
        center-focused-column = "never";
        preset-column-widths = [
          { proportion = 0.33; }
          { proportion = 0.5; }
          { proportion = 0.66; }
        ];
        default-column-width = { proportion = 0.5; };
      };

      # Window rules
      window-rules = [];

      # Prefer dark theme
      prefer-no-csd = true;

      # Keybindings
      binds = {
        # Mod key (Super/Windows key)
        "Mod+Return".action.spawn = "kitty";
        "Mod+D".action.spawn = "fuzzel";
        
        # Window management
        "Mod+Q".action.close-window = {};
        "Mod+Left".action.focus-column-left = {};
        "Mod+Right".action.focus-column-right = {};
        "Mod+Up".action.focus-window-up = {};
        "Mod+Down".action.focus-window-down = {};
        "Mod+H".action.focus-column-left = {};
        "Mod+L".action.focus-column-right = {};
        "Mod+K".action.focus-window-up = {};
        "Mod+J".action.focus-window-down = {};
        
        # Move windows
        "Mod+Shift+Left".action.move-column-left = {};
        "Mod+Shift+Right".action.move-column-right = {};
        "Mod+Shift+Up".action.move-window-up = {};
        "Mod+Shift+Down".action.move-window-down = {};
        "Mod+Shift+H".action.move-column-left = {};
        "Mod+Shift+L".action.move-column-right = {};
        "Mod+Shift+K".action.move-window-up = {};
        "Mod+Shift+J".action.move-window-down = {};
        
        # Workspaces
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        
        # Move window to workspace
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;
        
        # Column width
        "Mod+R".action.switch-preset-column-width = {};
        "Mod+Shift+R".action.reset-window-height = {};
        "Mod+F".action.maximize-column = {};
        "Mod+Shift+F".action.fullscreen-window = {};
        
        # Misc
        "Mod+Shift+E".action.quit = {};
        "Mod+Shift+P".action.power-off-monitors = {};
        
        # Screenshots
        "Print".action.spawn = ["sh" "-c" "grim -g \"$(slurp)\" - | wl-copy"];
        "Shift+Print".action.spawn = ["sh" "-c" "grim - | wl-copy"];
        
        # Volume keys (if available)
        "XF86AudioRaiseVolume".action.spawn = ["sh" "-c" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"];
        "XF86AudioLowerVolume".action.spawn = ["sh" "-c" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"];
        "XF86AudioMute".action.spawn = ["sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"];
        "XF86AudioMicMute".action.spawn = ["sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"];
        
        # Brightness keys (if available)
        "XF86MonBrightnessUp".action.spawn = ["sh" "-c" "brightnessctl set 5%+"];
        "XF86MonBrightnessDown".action.spawn = ["sh" "-c" "brightnessctl set 5%-"];
      };

      # Outputs (monitors) - can be customized per-host
      outputs = {};
    };
  };

  # Required packages for niri functionality
  home.packages = with pkgs; [
    grim        # Screenshot tool
    slurp       # Region selector
    wl-clipboard # Clipboard utilities
    brightnessctl # Brightness control
    pavucontrol # Audio control GUI
  ];
}
