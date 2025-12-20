# Niri Window Manager Setup Summary

## Overview
This document summarizes the niri window manager setup in this NixOS configuration for future reference.

## Implementation Details

### Configuration Structure

The niri setup is organized in a modular way:

- **System Module**: `modules/system/niri.nix`
  - Imports the niri-flake NixOS module
  - Enables niri as a session option
  - Uses `pkgs.niri` from nixpkgs (not from niri-flake)
  - Disables niri-flake's automatic cache configuration
  - Installs essential Wayland packages (wl-clipboard)

- **System Profile**: `profiles/system/niri.nix`
  - Simple wrapper that imports the system module

- **Home Module**: `modules/home/niri/niri.nix`
  - User-level niri configuration
  - Keybindings (Super+Return for terminal, Super+D for launcher, etc.)
  - Layout settings (gaps, column widths)
  - Input configuration (keyboard layout: DE, touchpad, mouse)
  - Environment variables (NIXOS_OZONE_WL for Electron apps)
  - Window rules and preferences

- **Home Profile**: `profiles/home/desktop.nix`
  - Imports niri home module
  - Imports waybar, fuzzel, and mako modules for complete desktop stack

### Key Configuration Choices

1. **Package Source**: Using `pkgs.niri` from nixpkgs instead of niri-flake
   - Reason: Binary cache availability from cache.nixos.org
   - Trade-off: Slower updates but no compilation needed
   - Set via: `programs.niri.package = pkgs.niri;`

2. **Dual Desktop Setup**: KDE Plasma 6 + Niri
   - KDE remains default desktop environment
   - Niri available as alternative session in SDDM
   - Users can switch at login screen

3. **Binary Cache Configuration**
   - Disabled niri-flake's automatic cache setup: `niri-flake.cache.enable = false;`
   - Kept niri.cachix.org in common.nix for potential future use
   - Uses cache.nixos.org for the actual niri package

4. **Trusted Users**
   - Added `trusted-users = [ "root" "@wheel" ];` in `profiles/system/common.nix`
   - Required for users to use binary cache configuration

### Issues Resolved

1. **`programs.xwayland-satellite.enable` doesn't exist**
   - Removed from configuration (commented out)
   - XWayland support is built into niri directly

2. **Build cache not working**
   - Initially tried to use niri-flake's binary cache
   - Cache didn't have the specific derivation for this system configuration
   - Solution: Switched to `pkgs.niri` from nixpkgs
   - Result: No compilation needed, downloads from cache.nixos.org

3. **Untrusted user warnings**
   - Added `trusted-users` to nix settings
   - Restarted nix-daemon to apply changes

### Host Configuration

In `hosts/laptop/default.nix`:
- System level: `../../profiles/system/niri.nix` is imported (always enabled)
- Home level: `../../profiles/home/desktop.nix` is commented out by default
   - Uncomment to enable waybar, fuzzel, mako for full desktop experience
  - Keep commented for minimal testing

### Documentation Created

- `docs/niri-shortcuts.md` - Complete keybinding reference
- `docs/niri-setup.md` - Installation and configuration guide
- `docs/niri-testing-with-kde.md` - How to test alongside KDE
- `docs/niri-post-install.md` - First login steps and verification
- `docs/shortcuts.md` - Updated to link to niri shortcuts

## Testing Niri

### Option 1: Log out and select session
```fish
qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logout
```
At SDDM login screen, select "niri" from session dropdown.

### Option 2: Nested window (quick test)
```fish
niri
```

### Option 3: TTY
Press `Ctrl + Alt + F2`, login, then:
```fish
niri-session
```

## Future Considerations

1. **Switching to niri-unstable**: If faster updates are needed, could switch back to niri-flake with:
   - Remove `package = pkgs.niri;` override
   - Re-enable niri-flake cache
   - Accept longer build times or set up local build cache

2. **Making niri default**: Can change SDDM default session or remove KDE packages

3. **Full desktop experience**: Uncomment niri home profile in `hosts/laptop/default.nix`

## Flake Inputs

```nix
niri = {
  url = "github:sodiboo/niri-flake";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

The niri input is present but we use `pkgs.niri` instead of the flake's package to avoid compilation.

## Build Time

- With niri-flake (compilation): ~40 minutes
- With pkgs.niri (download): ~1-2 minutes

## References

- Niri flake: https://github.com/sodiboo/niri-flake
- Niri compositor: https://github.com/YaLTeR/niri
- Pull Request: https://github.com/vii33/nixos-config/pull/6
