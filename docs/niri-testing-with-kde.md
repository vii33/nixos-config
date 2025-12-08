# Testing Niri Alongside KDE

This guide explains how to test niri while keeping KDE as your main desktop environment.

## Current Setup

The configuration now allows you to:
1. Keep KDE Plasma 6 with SDDM as your default desktop
2. Have niri available as an alternative session in SDDM
3. Test niri without replacing your current setup

## How to Test Niri

### Step 1: Build the Configuration

The niri system module is already enabled, which makes niri available as a session option:

```bash
sudo nixos-rebuild switch --flake .#laptop
```

### Step 2: Select Niri Session at Login

After rebuilding:
1. Log out of KDE (or reboot)
2. At the SDDM login screen, look for a session selector (usually in the top-left or bottom-left corner)
3. Select "niri" from the session list
4. Enter your password and log in

### Step 3: Enable Niri Home Configuration (Optional)

If you want waybar, fuzzel, and mako configured for niri:

Edit `hosts/laptop/default.nix` and uncomment this line:

```nix
home-manager.sharedModules =
  [
    inputs.nixvim.homeManagerModules.nixvim
    ../../profiles/home/niri.nix  # <-- Uncomment this line
    ../../profiles/home/desktop.nix
    ../../profiles/home/development-desktop.nix
    ../../profiles/home/development-headless.nix
  ];
```

Then rebuild:

```bash
sudo nixos-rebuild switch --flake .#laptop
```

### Step 4: Testing in Niri Session

Once logged into niri:
- Press `Super + Return` to open a terminal (kitty)
- Press `Super + D` to open the launcher (fuzzel) - only if home config is enabled
- See [docs/niri-shortcuts.md](niri-shortcuts.md) for all keybindings

### Step 5: Switch Back to KDE

To return to KDE:
1. Log out of niri (`Super + Shift + E` or from terminal: `niri msg action quit`)
2. At SDDM, select "Plasma (Wayland)" or "Plasma (X11)" session
3. Log in normally

## Full Switch to Niri (Optional)

If you want to make niri your default desktop permanently:

### Option A: Change Default Session in SDDM

After testing, you can set niri as the default session in SDDM settings, while keeping KDE available.

### Option B: Replace Display Manager

For a minimal setup with greetd+tuigreet instead of SDDM:

1. Edit `modules/system/niri.nix` and add back:
```nix
services.greetd = {
  enable = true;
  settings = {
    default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
      user = "greeter";
    };
  };
};
```

2. Edit `hosts/laptop/configuration.nix` and remove:
```nix
services.displayManager.sddm.enable = true;
services.desktopManager.plasma6.enable = true;
services.displayManager.autoLogin.enable = true;
services.displayManager.autoLogin.user = "vii";
```

3. Rebuild and reboot.

## Troubleshooting

### Niri Session Not Appearing in SDDM

If niri doesn't show up in the session list:
1. Check that `programs.niri.enable = true` is in your configuration
2. Rebuild with `sudo nixos-rebuild switch --flake .#laptop`
3. Look for niri session files in `/run/current-system/sw/share/wayland-sessions/` or `/run/current-system/sw/share/xsessions/`

### Blank Screen After Login

If niri starts but shows a blank screen:
1. Press `Super + Return` to open a terminal
2. Check niri logs: `journalctl --user -u niri -f` (if niri runs as a user service)
3. Or check system logs: `journalctl -xe | grep niri`

### Waybar/Fuzzel Not Working

These require the home-manager configuration. Make sure you:
1. Uncommented `../../profiles/home/niri.nix` in `hosts/laptop/default.nix`
2. Rebuilt the system
3. Logged out and back in to niri

### Want to Remove Niri

To remove niri and go back to KDE-only:
1. Remove `../../profiles/system/niri.nix` from `hosts/laptop/default.nix` imports
2. Remove `../../profiles/home/niri.nix` from home-manager.sharedModules (if uncommented)
3. Rebuild: `sudo nixos-rebuild switch --flake .#laptop`

## See Also

- [docs/niri-setup.md](niri-setup.md) - Full niri setup documentation
- [docs/niri-shortcuts.md](niri-shortcuts.md) - Complete keybinding reference
- [docs/niri-post-install.md](niri-post-install.md) - First login guide (for full switch)
