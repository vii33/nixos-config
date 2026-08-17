## Manual Post-Install Steps

Even with declarative NixOS a few one-time/manual actions are required when setting up a fresh machine or new user. This consolidates all imperative steps referenced in the Nix modules.

### 1. Set user password
```
sudo passwd vii
```

### 2. Clone Neovim config (for LazyVim)
`modules/home/neovim.nix` symlinks `~/.config/nvim` to `~/dev/neovim-config`, so clone the repo before launching Neovim:
```
mkdir -p ~/dev
cd ~/dev
git clone <your-neovim-config-repo-url> neovim-config
```

### 3. NBFC (Notebook Fan Control) – `laptop` host only
`hosts/laptop/nbfc.nix` expects `~/.config/nbfc.json` and a matching username (`myUser`). Create:
```
mkdir -p ~/.config
nano ~/.config/nbfc.json
```
Example content:
```
{
  "SelectedConfigId": "Xiaomi Mi Book (TM1613, TM1703)",
  "TargetFanSpeeds": [ 30.0, 30.0 ]
}
```
Then ensure service is active after rebuild:
```
systemctl status nbfc_service
```

### 4. Optional swapfile hibernation setup (`laptop` host)
The current `laptop` host uses a swap partition from `hosts/laptop/hardware-configuration.nix`.
Only use this recipe if you intentionally switch back to a swapfile-based hibernation setup.

Old swapfile settings that used to live in `hosts/laptop/swap.nix`:

```nix
swapDevices = [
  {
    device = "/swapfile";
    size = 12 * 1024;
    priority = 100;
  }
];

boot.resumeDevice = "/dev/disk/by-uuid/89a00461-4909-46da-ae07-1e17e5032e2b";
boot.kernelParams = [ "resume_offset=18022400" ];
```

Create the swapfile and calculate the correct `resume_offset`:

```
sudo dd if=/dev/zero of=/swapfile bs=1M count=12288 status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
filefrag -v /swapfile | awk '{ if($1=="0:"){print $4} }' | sed 's/..$//'   # capture number for resume_offset
```
Update `boot.kernelParams = [ "resume_offset=<NUMBER>" ];` and `boot.resumeDevice` (UUID of the underlying partition), then:
```
sudo nixos-rebuild switch --flake .#laptop
sudo systemctl hibernate   # test once
```

### 5. WireGuard VPN import (laptop)
Currently manually done in KDE/NetworkManager. Keep the imported interface name
as `wg0`; `hosts/laptop/configuration.nix` opens SSH only on that interface.

```
nmcli connection import type wireguard file my-wg-config.conf
nmcli connection modify <connection-name> connection.interface-name wg0
nmcli connection up <connection-name>
```

Optional future: declarative via `networking.wg-quick.interfaces`.

### 5a. Android/Termux SSH over WireGuard to laptop Herdr
On Android, connect to the same WireGuard network first (usually via the
WireGuard app). In Termux:

```
pkg update
pkg install openssh
ssh-keygen -t ed25519 -C "termux-phone"
cat ~/.ssh/id_ed25519.pub
```

Add that public key to `~/.ssh/authorized_keys` for `vii` on the laptop, then:

```
ssh vii@<laptop-wireguard-ip>
herdr
```

For a shortcut, add this to `~/.ssh/config` in Termux:

```
Host laptop-herdr
  HostName <laptop-wireguard-ip>
  User vii
  IdentityFile ~/.ssh/id_ed25519
```

Then connect with `ssh laptop-herdr`.

### 6. Clipboard provider choice
Wayland: `wl-clipboard` is already included. For X11 switch to `xclip` in `modules/home/neovim.nix` and rebuild.

### 7. Additional dev repos
Clone any other personal repos to `~/dev/` if you plan to symlink them similarly.

### 8. SSH keys (not stored in repo)
```
ssh-keygen -t ed25519 -C "vii@<host>"
```
Add public key to forges/services manually.

### 9. NVIDIA verification (laptop)
```
nvidia-smi
glxinfo -B | grep -E 'OpenGL vendor|OpenGL renderer'
```

### 10. Fingerprint reader enrollment (laptop)
If your laptop has a fingerprint reader and `services.fprintd.enable = true` is set in `hosts/laptop/configuration.nix`, enroll your fingerprint after rebuild:
```bash
# Check if your fingerprint reader is detected
lsusb | grep -i finger

# Enroll your fingerprint (follow prompts to swipe finger multiple times)
fprintd-enroll

# Test fingerprint authentication
fprintd-verify
```
Once enrolled, fingerprint works automatically for sudo, login (SDDM/KDE or niri if using greetd), and screen unlock.

### 11. Disable macOS Finder search shortcut (macOS work host / Ghostpepper)
On a new Mac, `⌥⌘Space` (Option + Command + Space) opens the "Finder search window" by default, which conflicts when using Ghostpepper.
Disable it via **System Settings -> Keyboard -> Keyboard Shortcuts -> Spotlight -> uncheck "Show Finder search window"** (or see `docs/darwin.md` for CLI command).

## Restoring / Notes

These steps are typically one-time and are not managed by the repo. Where applicable, the README links back to other docs (e.g., `docs/backup.md`) for backups and manual scripts.
