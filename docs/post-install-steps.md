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

### 4. Create swapfile & set hibernation offset (`laptop` host)
`hosts/laptop/swap.nix` assumes an existing `/swapfile` and a correct `resume_offset`:
```
sudo dd if=/dev/zero of=/swapfile bs=1M count=12288 status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
filefrag -v /swapfile | awk '{ if($1=="0:"){print $4} }' | sed 's/..$//'   # capture number for resume_offset
```
Update `boot.kernelParams = ["resume_offset=<NUMBER>"];` and `boot.resumeDevice` (UUID of underlying partition) in `swap.nix`, then:
```
sudo nixos-rebuild switch --flake .#laptop
sudo systemctl hibernate   # test once
```

### 5. WireGuard VPN import (laptop)
Currently manually done in KDE.
Alternative: `hosts/laptop/configuration.nix`:
```
nmcli connection import type wireguard file my-wg-config.conf
```
Optional future: declarative via `networking.wg-quick.interfaces`.

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

## Restoring / Notes

These steps are typically one-time and are not managed by the repo. Where applicable, the README links back to other docs (e.g., `docs/backup.md`) for backups and manual scripts.