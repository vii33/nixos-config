# Linux / NixOS hosts

## Hosts

- `laptop`: full desktop system with KDE Plasma 6 and niri available as an alternate session.
- `home-server`: minimal headless server, still WIP.

## Build commands

```bash
# Test without switching
nixos-rebuild --dry-run --flake .#laptop
nixos-rebuild --dry-run --flake .#home-server

# Activate intentionally
nixos-rebuild switch --flake .#laptop
nixos-rebuild switch --flake .#home-server
```

## Laptop bootloader workaround

The laptop has corrupted EFI NVRAM variables that can make `bootctl status` crash. If
`nixos-rebuild switch` fails with `SIGABRT` during bootloader installation, use the
workaround script:

```bash
sudo fish docs/nixos-rebuild-workaround.fish
```

The script builds and activates the config with `nixos-rebuild test`, sets it as the
system profile, then manually creates the boot entry and updates the default.

## Niri window manager

The laptop has niri available as an alternative session alongside KDE.

To test niri:

1. Log out of the current session.
2. At the SDDM login screen, select `niri` from the session dropdown.
3. Log in.
4. Use `Super + Return` for a terminal and `Super + 1-9` for workspaces.

More details:

- [niri setup](niri/niri-setup.md)
- [niri testing with KDE](niri/niri-testing-with-kde.md)
- [niri shortcuts](keyboard-shortcuts/niri-shortcuts.md)
