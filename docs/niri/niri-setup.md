# Niri Window Manager Setup

This document describes the niri Wayland compositor setup in this configuration.

## Testing vs Full Switch

**Want to try niri without replacing KDE?** See [docs/niri-testing-with-kde.md](niri-testing-with-kde.md) for instructions on how to test niri as an alternative session while keeping KDE as your default desktop.

This document describes the full niri setup. By default, the configuration allows testing niri alongside KDE.

## Overview

Niri is a scrollable-tiling Wayland compositor with a focus on simplicity and usability. This configuration supports:

- **niri** - The window manager/compositor
- **waybar** - Status bar with systemd integration (optional)
- **fuzzel** - Application launcher (optional)
- **mako** - Notification daemon (optional)
- **SDDM** - Display manager (allows choosing between KDE and niri)
- **KDE Plasma 6** - Available as alternative desktop (default)

## Components

### System Level (`modules/system/niri.nix`)

- Imports the niri module from `sodiboo/niri-flake`
- Enables niri and xwayland-satellite for X11 app support
- Makes niri available as a session option in SDDM
- Works alongside KDE without conflicts

### Home Manager Level (`modules/home/niri.nix`)

- Configures niri settings (keybindings, layout, etc.)
- Sets `NIXOS_OZONE_WL=1` for better Electron app support (VSCode, etc.)
- Defines comprehensive keybindings (see `docs/niri-shortcuts.md`)
- Configures spawn-at-startup to reset waybar service
- **Note**: This is optional and commented out by default in `hosts/laptop/default.nix`

### Supporting Applications

#### Waybar (`modules/home/waybar.nix`)
- Status bar with workspace, window title, system info
- Systemd integration for proper session management
- Custom styling with Dracula-inspired theme
- Requires reset-failed workaround in niri spawn-at-startup

#### Fuzzel (`modules/home/fuzzel.nix`)
- Application launcher with fuzzy search
- Configured with Dracula colors
- Launched with `Super + D`

#### Mako (`modules/home/mako.nix`)
- Notification daemon
- Positioned at top-right
- Dracula-inspired theme

## Binary Cache

The niri binary cache is configured in `profiles/system/common.nix`:

```nix
substituters = [
  "https://cache.nixos.org"
  "https://niri.cachix.org"
];
trusted-public-keys = [
  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
];
```

This significantly speeds up niri builds by using pre-built binaries.

## Login

After building this configuration:

1. Reboot or switch to a TTY
2. You'll see the tuigreet login screen
3. Enter your username and password
4. The system will start `niri-session` automatically

## Usage

### Basic Navigation

- `Super + Return` - Open terminal
- `Super + D` - Open launcher
- `Super + Q` - Close window
- `Super + 1-9` - Switch workspaces
- `Super + Shift + 1-9` - Move window to workspace

See `docs/shortcuts.md` for the complete list of keybindings.

### Scrollable Tiling

Niri uses a unique scrollable tiling layout:
- Windows are organized in columns
- Use `Super + Left/Right` to switch between columns
- Use `Super + R` to cycle through preset column widths (33%, 50%, 66%)
- Use `Super + F` to maximize the current column

### Screenshots

- `Print` - Select region with cursor, screenshot goes to clipboard
- `Shift + Print` - Screenshot entire screen to clipboard

Requires `grim` and `slurp` (automatically included).

## Configuration Files

The niri configuration is spread across several files:

```
├── flake.nix                    # Adds niri flake input
├── modules/
│   ├── system/niri.nix         # System-level niri config
│   └── home/
│       ├── niri.nix            # Home-manager niri config
│       ├── waybar.nix          # Status bar
│       ├── fuzzel.nix          # Launcher
│       └── mako.nix            # Notifications
├── profiles/
│   ├── system/niri.nix         # System profile
│   └── home/niri.nix           # Home profile
└── hosts/laptop/
    └── default.nix             # Imports niri profiles
```

## Customization

### Changing Keybindings

Edit `modules/home/niri.nix` under the `binds` section.

### Monitor Configuration

Add output configuration in `modules/home/niri.nix`:

```nix
outputs = {
  "eDP-1" = {
    scale = 1.5;
    mode = {
      width = 2560;
      height = 1600;
      refresh = 60.0;
    };
  };
};
```

### Window Rules

Add window-specific rules in `modules/home/niri.nix`:

```nix
window-rules = [
  {
    matches = [{ app-id = "firefox"; }];
    default-column-width = { proportion = 0.66; };
  }
];
```

## Troubleshooting

### Waybar not starting

The waybar systemd service has a restart limit. The configuration includes a workaround:
- `systemctl --user reset-failed waybar.service` is run at startup
- This is configured in `modules/home/niri.nix` under `spawn-at-startup`

### Electron apps (VSCode) not using Wayland

Check that `NIXOS_OZONE_WL=1` is set:
```bash
echo $NIXOS_OZONE_WL
```

This is configured in `modules/home/niri.nix`.

### XWayland apps not working

Ensure xwayland-satellite is running:
```bash
systemctl --user status xwayland-satellite
```

This is enabled in `modules/system/niri.nix`.

## References

- [niri documentation](https://github.com/YaLTeR/niri)
- [sodiboo/niri-flake](https://github.com/sodiboo/niri-flake)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
