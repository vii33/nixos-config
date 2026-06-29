# modules/home/niri/niri.nix
# Home Manager configuration for niri Wayland compositor
{
  config,
  pkgs,
  lib,
  niriWallpaper ? null,
  ...
}:

let
  noctaliaShell = lib.getExe config.programs.noctalia-shell.package;
  keyboardBacklightCycle = pkgs.writeShellScript "keyboard-backlight-cycle" ''
    device='tpacpi::kbd_backlight'
    current=$(${lib.getExe pkgs.brightnessctl} --device="$device" get)

    if [ "$current" -eq 0 ]; then
      ${lib.getExe pkgs.brightnessctl} --device="$device" set 1
    else
      ${lib.getExe pkgs.brightnessctl} --device="$device" set 0
    fi
  '';
  screenshotAnnotate = pkgs.writeShellScript "niri-screenshot-annotate" ''
    set -eu

    mode="''${1:-region}"
    tmp="''${XDG_RUNTIME_DIR:-/tmp}/niri-screenshot-$(date +%s%N).png"

    cleanup() {
      rm -f "$tmp"
    }
    trap cleanup EXIT

    case "$mode" in
      region)
        geometry="$(${lib.getExe pkgs.slurp})"
        ${lib.getExe pkgs.grim} -g "$geometry" "$tmp"
        ;;
      full)
        ${lib.getExe pkgs.grim} "$tmp"
        ;;
      *)
        printf 'usage: %s [region|full]\n' "$0" >&2
        exit 2
        ;;
    esac

    ${lib.getExe pkgs.swappy} -f "$tmp"
  '';
  wallpaper =
    if niriWallpaper != null then
      toString niriWallpaper
    else
      "${config.home.homeDirectory}/Pictures/Wallpapers/alghozy-7TfUCBVR0nI-unsplash.jpg";
in
{
  programs.niri = {
    settings = {
      # Environment variables
      environment = {
        NIXOS_OZONE_WL = "1"; # Enable Wayland for Electron apps
        ELECTRON_OZONE_PLATFORM_HINT = "auto"; # Standard hint for Electron
        DISPLAY = ":0"; # Required for XWayland compatibility (via xwayland-satellite)
      };

      # Spawn commands at startup
      spawn-at-startup = [
        # Background wallpaper
        {
          command = [
            "${pkgs.swaybg}/bin/swaybg"
            "-i"
            wallpaper
            "-m"
            "fill"
          ];
        }
        # Noctalia Shell replaces Waybar for the Niri panel and desktop shell.
        { command = [ noctaliaShell ]; }
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
          scroll-factor = 0.24;
        };
        mouse = {
          natural-scroll = false;
        };
      };

      # Workspace names
      workspaces = {
        "1" = {
          name = "main";
        };
        "2" = {
          name = "code";
        };
        "3" = {
          name = "web";
        };
      };

      # Layout configuration
      layout = {
        gaps = 0;
        center-focused-column = "never";
        struts = {
          top = 4;
          bottom = 4;
        };
        preset-column-widths = [
          { proportion = 0.33; }
          { proportion = 0.5; }
          { proportion = 0.66; }
        ];
        default-column-width = {
          proportion = 0.5;
        };
      };

      # Window rules
      window-rules = [
        # Example: Open VSCode in a specific way if needed
        # { matches = [{ app-id = "code"; }]; open-maximized = true; }
      ];

      # Prefer dark theme
      prefer-no-csd = true;

      overview = {
        backdrop-color = "#101014";
        workspace-shadow = {
          softness = 40;
          spread = 10;
          offset = {
            x = 0;
            y = 10;
          };
          color = "#00000070";
        };
      };

      hotkey-overlay = {
        skip-at-startup = true;
      };

      # Keybindings
      binds = {
        # Mod key (Super/Windows key)
        "Mod+Return".action.spawn = "ghostty";
        "Alt+Return".action.spawn = "ghostty";
        # Noctalia Shell provides the launcher.
        "Mod+Space".action.spawn = [
          noctaliaShell
          "ipc"
          "call"
          "launcher"
          "toggle"
        ];

        # Window management
        "Mod+Q".action.close-window = { };
        "Mod+Left".action.focus-column-left = { };
        "Mod+Right".action.focus-column-right = { };
        "Mod+Up".action.focus-workspace-up = { };
        "Mod+Down".action.focus-workspace-down = { };
        "Mod+H".action.focus-column-left = { };
        "Mod+L".action.focus-column-right = { };
        "Mod+K".action.focus-workspace-up = { };
        "Mod+J".action.focus-workspace-down = { };

        # Move windows
        "Mod+Shift+Left".action.move-column-left = { };
        "Mod+Shift+Right".action.move-column-right = { };
        "Mod+Shift+Up".action.move-column-to-workspace-up = { };
        "Mod+Shift+Down".action.move-column-to-workspace-down = { };
        "Mod+Shift+H".action.move-column-left = { };
        "Mod+Shift+L".action.move-column-right = { };
        "Mod+Shift+K".action.move-window-up = { };
        "Mod+Shift+J".action.move-window-down = { };

        # Move windows between monitors
        "Mod+Ctrl+Alt+Left".action.move-column-to-monitor-left = { };
        "Mod+Ctrl+Alt+Right".action.move-column-to-monitor-right = { };
        "Mod+Ctrl+Alt+H".action.move-column-to-monitor-left = { };
        "Mod+Ctrl+Alt+L".action.move-column-to-monitor-right = { };

        # Workspaces
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;

        # Move window to workspace
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;

        # Column width
        "Mod+R".action.switch-preset-column-width = { };
        "Mod+Shift+R".action.reset-window-height = { };
        "Mod+F".action.maximize-column = { };
        "Mod+Shift+F".action.fullscreen-window = { };

        # Misc
        "Mod+question".action.show-hotkey-overlay = { };
        "Mod+Shift+Slash".action.show-hotkey-overlay = { };
        "Mod+Shift+E".action.quit = { };
        "Mod+Shift+P".action.power-off-monitors = { };

        # Advanced Niri Features
        "Mod+C".action.center-column = { };
        "Mod+O".action.toggle-overview = { };
        "Mod+W".action.toggle-column-tabbed-display = { };
        "Mod+V".action.toggle-window-floating = { };
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = { };

        # Window resizing
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        # Column merging (Consume/Expel) with ö/ä
        "Mod+odiaeresis".action.consume-or-expel-window-left = { };
        "Mod+adiaeresis".action.consume-or-expel-window-right = { };

        # Screenshots
        "Print".action.spawn = [
          "${screenshotAnnotate}"
          "region"
        ];
        "Shift+Print".action.spawn = [
          "${screenshotAnnotate}"
          "full"
        ];

        # Volume/Brightness keys
        "XF86AudioRaiseVolume".action.spawn = [
          "sh"
          "-c"
          "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ];
        "XF86AudioLowerVolume".action.spawn = [
          "sh"
          "-c"
          "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];
        "XF86AudioMute".action.spawn = [
          "sh"
          "-c"
          "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ];
        "XF86AudioMicMute".action.spawn = [
          "sh"
          "-c"
          "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ];
        "XF86MonBrightnessUp".action.spawn = [
          "sh"
          "-c"
          "brightnessctl set 5%+"
        ];
        "XF86MonBrightnessDown".action.spawn = [
          "sh"
          "-c"
          "brightnessctl set 5%-"
        ];
        "XF86KbdBrightnessUp".action.spawn = [
          "${keyboardBacklightCycle}"
        ];
        "XF86Tools".action.spawn = [
          "${keyboardBacklightCycle}"
        ];
        "XF86KbdBrightnessDown".action.spawn = [
          "${lib.getExe pkgs.brightnessctl}"
          "--device=tpacpi::kbd_backlight"
          "set"
          "1-"
        ];

        # Mouse/Touchpad binds
        "Mod+WheelScrollDown".action.focus-column-right = { };
        "Mod+WheelScrollUp".action.focus-column-left = { };
        "Mod+TouchpadScrollDown".action.focus-column-right = { };
        "Mod+TouchpadScrollUp".action.focus-column-left = { };
      };

      # Outputs (monitors) - can be customized per-host
      outputs = {
        "eDP-1" = {
          # Laptop screen on the left
          position = {
            x = 0;
            y = 0;
          };
          scale = 1.2;
        };
        "Dell Inc. DELL S2721DGF 6RG6S83" = {
          # External monitor on the right, matched by identity to survive DP port renumbering.
          position = {
            x = 2134; # Width of laptop screen in logical pixels: 2560 / 1.2.
            y = 0;
          };
          focus-at-startup = true;
        };
      };
    };
  };

  # Required packages for niri functionality
  home.packages = with pkgs; [
    swaybg # Background/wallpaper utility
    grim # Wayland screenshot capture backend
    slurp # Interactive region selector for screenshots
    swappy # Lightweight screenshot annotation/crop UI
    wl-clipboard # Clipboard backend used by screenshot tools
    brightnessctl # Brightness control
    pavucontrol # Audio control GUI
    wtype # Wayland text injection for Handy transcriptions
    xwayland-satellite # X11 compatibility layer (Crucial for newer Niri)
    xdg-desktop-portal-gnome # Needed for file pickers etc in Electron apps
    polkit_gnome # Authentication agent
    networkmanagerapplet # Network manager tray icon
  ];
}
