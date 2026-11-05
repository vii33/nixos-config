# Linux / NixOS hosts

## Hosts

- `laptop`: full desktop system with KDE Plasma 6 and niri available as an alternate session.
- `home-server`: Docker host with a headless IceWM desktop.
- `agent-host`: agent VM with a headless IceWM desktop and Obsidian.

## Server desktops (IceWM / VNC)

Both servers run a persistent IceWM session as the configured server user on X display
`:1` (1600×1000). TigerVNC provides the virtual display, so no monitor or display manager
is needed. Disconnecting VNC leaves applications running.

After building and activating the relevant host configuration, connect through SSH:

```bash
ssh -N -L 5901:127.0.0.1:5901 vii@agent-host
# Or use vii@home-server instead.
```

Point your VNC viewer at `127.0.0.1:5901` (TigerVNC syntax: `127.0.0.1::5901`).
SSH supplies authentication and encryption; the VNC listener is localhost-only and has
no separate password. Local processes on the host can access the desktop. No VNC firewall
port is opened. Use a different local port, such as `5902`, for a second simultaneous tunnel.

From an SSH shell or an agent running as the server user:

```bash
systemctl --user status server-desktop
systemctl --user restart server-desktop
journalctl --user -u server-desktop -b
DISPLAY=:1 obsidian  # Installed on agent-host.
DISPLAY=:1 import -window root /tmp/desktop.png
DISPLAY=:1 xdotool getactivewindow getwindowname
```

Set `DISPLAY=:1` for commands that should interact with this desktop. An Xterm terminal
is also installed for interactive use from IceWM. The user service starts at boot via
systemd lingering; restarting it closes the running desktop applications.

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
