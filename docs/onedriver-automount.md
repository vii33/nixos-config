# OneDriver Auto-Mount on Startup Solution

## Problem
The onedriver application was not automatically mounting the OneDrive folder on login, even though "automount on startup" was enabled in the app settings.

## Root Cause
OneDriver has two ways to run:
1. **GUI launcher mode** - via the onedriver-launcher desktop app (interactive)
2. **Systemd service mode** - as a user systemd service (background daemon)

The GUI setting only works if the app is running interactively. On NixOS, we need to ensure onedriver runs as a **systemd user service** to mount automatically on login.

## Solution Implemented

### Changes Made

1. **Created `/modules/home/onedriver.nix`** - A new Home Manager module that:
   - Creates the `~/OneDrive` mount point
   - Configures a systemd user service `onedriver-onedrive` to start on login
   - Sets up proper ordering (waits for network to be online)
   - Includes automatic restart on failure

2. **Updated `/profiles/home/desktop.nix`** to:
   - Import the new `onedriver.nix` module
   - Remove the raw package reference (now managed by the module)

## How It Works

When you rebuild:
```fish
sudo nixos-rebuild switch --flake .#laptop
```

The systemd service will be installed in your user session. It will:
- Automatically mount OneDrive at `~/OneDrive` on login
- Survive service restarts if it crashes
- Start after network connectivity is available

## Manual Control

After applying the config, you can manually control the service:

```fish
# Start the service immediately (mount now)
systemctl --user start onedriver-onedrive

# Stop the service (unmount)
systemctl --user stop onedriver-onedrive

# Check status
systemctl --user status onedriver-onedrive

# View recent logs
journalctl --user -u onedriver-onedrive --since today

# Enable/disable on login
systemctl --user enable onedriver-onedrive
systemctl --user disable onedriver-onedrive
```

## Troubleshooting

If OneDriver doesn't mount on login:

1. **Check service status:**
   ```fish
   systemctl --user status onedriver-onedrive
   ```

2. **View detailed logs:**
   ```fish
   journalctl --user -u onedriver-onedrive --since today -n 50
   ```

3. **Check if the service is enabled:**
   ```fish
   systemctl --user is-enabled onedriver-onedrive
   ```

4. **If authentication fails**, you may need to:
   - Authenticate with your Microsoft account first (run onedriver manually once)
   - Check `~/.cache/onedriver/` for cached credentials
   - Remove the cache if needed and re-authenticate

5. **Mount point issues:**
   - Ensure `~/OneDrive` directory exists and is writable
   - Check available disk space
   - Verify network connectivity

## References

- OneDriver GitHub: https://github.com/jstaf/onedriver
- Systemd user services: https://wiki.archlinux.org/title/Systemd/User
