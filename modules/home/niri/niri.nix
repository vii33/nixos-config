# modules/home/niri/niri.nix
# Home Manager configuration for niri Wayland compositor
{ config, pkgs, lib, ... }:

{
  programs.niri = {
    settings = {
      # Environment variables
      environment = {
        NIXOS_OZONE_WL = "1";  # Enable Wayland for Electron apps
        ELECTRON_OZONE_PLATFORM_HINT = "auto"; # Standard hint for Electron
        DISPLAY = ":0"; # Required for XWayland compatibility (via xwayland-satellite)
      };

      # Spawn commands at startup
      spawn-at-startup = [
        # Mako notification daemon
        { command = [ "systemctl" "--user" "reset-failed" "mako.service" ]; }
        { command = [ "systemctl" "--user" "start" "mako.service" ]; }
        # Reset waybar service
        { command = [ "systemctl" "--user" "reset-failed" "waybar.service" ]; }
        { command = [ "systemctl" "--user" "start" "waybar.service" ]; }
        # XWayland Satellite for X11 apps (REQUIRED for Niri >= 0.1.10)
        { command = [ "${lib.getExe pkgs.xwayland-satellite}" ]; }
        # Polkit Agent
        { command = [ "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" ]; }
        # NetworkManager Applet
        { command = [ "${pkgs.networkmanagerapplet}/bin/nm-applet" ]; }
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
          dwt = true;
          # accel-profile = "flat";
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
      window-rules = [
        # Example: Open VSCode in a specific way if needed
        # { matches = [{ app-id = "code"; }]; open-maximized = true; }
      ];

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
        "Mod+Up".action.focus-workspace-up = {};
        "Mod+Down".action.focus-workspace-down = {};
        "Mod+H".action.focus-column-left = {};
        "Mod+L".action.focus-column-right = {};
        "Mod+K".action.focus-window-up = {};
        "Mod+J".action.focus-window-down = {};
        
        # Move windows
        "Mod+Shift+Left".action.move-column-left = {};
        "Mod+Shift+Right".action.move-column-right = {};
        "Mod+Shift+Up".action.move-column-to-workspace-up = {};
        "Mod+Shift+Down".action.move-column-to-workspace-down = {};
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
      
        # Move window to workspace
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        
        # Column width
        "Mod+R".action.switch-preset-column-width = {};
        "Mod+Shift+R".action.reset-window-height = {};
        "Mod+F".action.maximize-column = {};
        "Mod+Shift+F".action.fullscreen-window = {};
        
        # Misc
        "Mod+Shift+Slash".action.show-hotkey-overlay = {};
        "Mod+Shift+E".action.quit = {};
        "Mod+Shift+P".action.power-off-monitors = {};

        # Advanced Niri Features
        "Mod+C".action.center-column = {};
        "Mod+O".action.toggle-overview = {};
        "Mod+W".action.toggle-column-tabbed-display = {};
        "Mod+V".action.toggle-window-floating = {};
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = {};

        # Window resizing
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        # Column merging (Consume/Expel) with ö/ä
        "Mod+odiaeresis".action.consume-or-expel-window-left = {};
        "Mod+adiaeresis".action.consume-or-expel-window-right = {};
        
        # Screenshots
        "Print".action.spawn = ["sh" "-c" "grim -g \"$(slurp)\" - | wl-copy"];
        "Shift+Print".action.spawn = ["sh" "-c" "grim - | wl-copy"];
        
        # Volume/Brightness keys
        "XF86AudioRaiseVolume".action.spawn = ["sh" "-c" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"];
        "XF86AudioLowerVolume".action.spawn = ["sh" "-c" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"];
        "XF86AudioMute".action.spawn = ["sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"];
        "XF86AudioMicMute".action.spawn = ["sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"];
        "XF86MonBrightnessUp".action.spawn = ["sh" "-c" "brightnessctl set 5%+"];
        "XF86MonBrightnessDown".action.spawn = ["sh" "-c" "brightnessctl set 5%-"];

        # Mouse/Touchpad binds
        "Mod+WheelScrollDown".action.focus-column-right = {};
        "Mod+WheelScrollUp".action.focus-column-left = {};
        "Mod+TouchpadScrollDown".action.focus-column-right = {};
        "Mod+TouchpadScrollUp".action.focus-column-left = {};
      };

      # Outputs (monitors) - can be customized per-host
      outputs = {};
    };
  };

  # Required packages for niri functionality
  home.packages = with pkgs; [
    grim           # Screenshot tool
    slurp          # Region selector
    wl-clipboard   # Clipboard utilities
    brightnessctl  # Brightness control
    pavucontrol    # Audio control GUI
    xwayland-satellite # X11 compatibility layer (Crucial for newer Niri)
    xdg-desktop-portal-gnome # Needed for file pickers etc in Electron apps
    polkit_gnome   # Authentication agent
    networkmanagerapplet # Network manager tray icon
  ];
}
