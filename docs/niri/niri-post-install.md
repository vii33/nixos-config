# Post-Installation Steps for Niri

After building the configuration with `sudo nixos-rebuild switch --flake .#laptop`, follow these steps:

## 1. Reboot or Switch to TTY

Press `Ctrl + Alt + F2` to switch to a TTY, or simply reboot your system.

## 2. Login with greetd/tuigreet

You will see the tuigreet login screen. Enter your username and password.

## 3. First Login

After logging in, niri will start automatically. You should see:
- Waybar at the top of the screen showing workspaces and system info
- A clean desktop without windows

## 4. Basic First Steps

### Open a Terminal
Press `Super + Return` to open Kitty terminal.

### Launch Applications
Press `Super + D` to open fuzzel launcher, then type the application name.

### Test Notifications
```bash
notify-send "Test" "Notification system is working"
```

## 5. Verify Components

### Check Waybar
Waybar should be visible at the top. If not:
```bash
systemctl --user status waybar
systemctl --user restart waybar
```

### Check Mako (Notifications)
```bash
systemctl --user status mako
```

## 6. Application Compatibility

### Electron Apps (VSCode, etc.)
Electron apps should automatically use Wayland thanks to `NIXOS_OZONE_WL=1`. Verify:
```bash
echo $NIXOS_OZONE_WL
# Should output: 1
```

### Firefox
Firefox should use Wayland by default. To verify:
```bash
# In Firefox, type in address bar:
about:support
# Look for "Window Protocol" - should say "wayland"
```

## 7. Common Issues

### Waybar Not Starting
This is handled by the spawn-at-startup configuration, but if waybar still doesn't start:
```bash
systemctl --user reset-failed waybar.service
systemctl --user start waybar.service
```

### Screen Blank / No Output
Check niri logs:
```bash
journalctl --user -u niri -f
```

### Keyboard Layout Not Working
The keyboard layout is set to German (`de`) in the configuration. To change it:
- Edit `modules/home/niri/niri.nix` and change the `layout` under `input.keyboard.xkb`
- Rebuild and relogin

## 8. Customization

See [docs/niri-setup.md](niri-setup.md) for:
- Monitor configuration
- Custom keybindings
- Window rules
- And more

## 9. Screenshots

Test screenshot functionality:
- Press `Print` - Use mouse to select region
- Press `Shift + Print` - Capture entire screen
- Screenshots go to clipboard - paste with `Ctrl + V`

## 10. Enjoy!

You now have a working niri environment! See [docs/shortcuts.md](shortcuts.md) for all keybindings.
