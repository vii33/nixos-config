# NixOS Configuration 🌚🌠

Personal NixOS configuration using flakes and Home Manager.

## Repository Structure

- `flake.nix` - Main flake configuration defining system builds
- `hosts/` - Host-specific configurations
  - `laptop/` - laptop configuration 
  - `home-server/` - Headless server 
  - `work/` - WSL laptop 
- `modules/` - Reusable NixOS modules
- `profiles/` - Used in hosts, composes `modules`

## Usage

### Building Configurations

```bash
# Build and switch laptop configuration
sudo nixos-rebuild switch --flake .#laptop

# Build home-server configuration  
sudo nixos-rebuild switch --flake .#home-server

# Test configuration without switching
sudo nixos-rebuild test --flake .#laptop
```


## Manual Post-Install Steps 🛠️

Even with declarative NixOS + Home Manager, a few one-time/manual actions are required when setting up a fresh machine or new user. This consolidates all imperative steps referenced in the Nix modules.

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

### 3. NBFC (Notebook Fan Control) – laptop only
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

### 4. Create swapfile & set hibernation offset (laptop)
`hosts/laptop/swap.nix` assumes an existing `/swapfile` and a correct `resume_offset`.
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
Currently manual (NetworkManager), per comment in `hosts/laptop/configuration.nix`:
```
nmcli connection import type wireguard file my-wg-config.conf
```
Optional future: declarative via `networking.wg-quick.interfaces`.

### 6. Clipboard provider choice
Wayland: `wl-clipboard` is already included. For X11 switch to `xclip` in `modules/home/neovim.nix` and rebuild.
### 7. Additional dev repos
Clone any other personal repos to `~/dev/` if you plan to symlink them similarly.
### 8. Docker group session refresh
User `vii` is already in `docker`. If permission denied right after first login, log out/in or:
```
sudo systemctl restart docker
```

### 9. SSH keys (not stored in repo)
```
ssh-keygen -t ed25519 -C "vii@<host>"
```
Add public key to forges/services manually.

### 10. NVIDIA verification (laptop)
```
nvidia-smi
glxinfo -B | grep -E 'OpenGL vendor|OpenGL renderer'
```
### 11. Cleanup Home Manager backups
Existing files overwritten get a `.backup` suffix:
```
find ~ -name '*.backup' -maxdepth 4
```

### 12. Update flake inputs (maintenance)
```
nix flake update
sudo nixos-rebuild switch --flake .#<host>
```

### 13. (Future improvements – not yet automatic)
- Make NBFC JSON generation declarative (e.g. with a `home.file` entry gated by host)
- Declarative WireGuard interface(s)
- Automate swapfile creation & resume offset derivation (systemd tmpfiles + script)
- Introduce sops-nix or similar for secrets (VPN keys, etc.)


## Development

This repository includes comprehensive Copilot instructions in `.github/instructions/` to assist with:
- NixOS configuration best practices
- Repository structure guidance
- Host-specific configuration details
- Module development patterns

## Key Features

- **Flake-based**: Modern Nix flakes for reproducible configurations
- **Home Manager**: User environment management
- **Multi-host**: Support for laptop and server configurations
- **Hardware Support**: NVIDIA graphics, NBFC fan control
- **Shell Configuration**: Fish shell with Tide prompt
