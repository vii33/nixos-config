# NixOS Configuration 🌚🌠

Personal NixOS configuration using flakes and Home Manager.

## Key Features

This a NixOS configuration repository designed for managing multiple hosts with a consistent setup. It is based on three tiers:

- **Modules** (reusable building blocks) — `modules/system/` and `modules/home/`
- **Profiles** (compositions of modules for defined use cases) — `profiles/system/` and `profiles/home/`
- **Hosts** (specific machines with assigned profiles) — `hosts/laptop/`, `hosts/home-server/`, etc.

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│ MODULES (Reusable Components)                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  System Modules:              Home Modules:                     │
│  ├─ user.nix                  ├─ fish-shell.nix                 │
│  └─ ...                       ├─ kitty.nix                      │
│                               ├─ neovim.nix                     │
│                               ├─ nixvim/lazyvim.nix             │
│                               └─ ...                            │
└─────────────────────────────────────────────────────────────────┘
                                    ▲
                                    │ imports
                                    │
┌─────────────────────────────────────────────────────────────────┐
│ PROFILES (Composed Use Cases)                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  System Profiles:             Home Profiles:                    │
│  ├─ common.nix                ├─ desktop.nix                    │
│  ├─ desktop.nix               └─ development-desktop.nix        │
│  ├─ development-headless.nix                                    │
│  └─ server.nix                                                  │
│                                                                 │
│  Example: "laptop" needs common + desktop + development         │
│           "home-server" needs common only                       │
└─────────────────────────────────────────────────────────────────┘
                                    ▲
                                    │ imports
                                    │
┌─────────────────────────────────────────────────────────────────┐
│ HOSTS (Specific Machines)                                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  hosts/laptop/default.nix                                       │
│  ├─ imports common.nix                                          │
│  ├─ imports desktop.nix                                         │
│  ├─ imports development-headless.nix                            │
│  ├─ imports user.nix                                            │
│  ├─ imports configuration.nix (laptop-specific)                 │
│  ├─ imports hardware-configuration.nix (laptop hardware)        │
│  └─ imports swap.nix, nbfc.nix (laptop-specific services)       │
│                                                                 │
│  hosts/home-server/default.nix                                  │
│  ├─ imports common.nix                                          │
│  ├─ imports server.nix                                          │
│  ├─ imports user.nix                                            │
│  └─ imports configuration.nix (server-specific)                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Keyboard Shortcuts

See [docs/shortcuts.md](docs/shortcuts.md) for a complete list of keyboard shortcuts and shell abbreviations for Fish shell, Kitty terminal, and FZF.



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

-----

## Manual Post-Install Steps 🛠️

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

## Future improvements – not yet automatic
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


## Backups

Nix and Home Manager restore the system and most dotfiles, but some personal data and runtime state lives outside this repo. Back up the items below regularly, especially before reinstalling or migrating.

| Item | Path(s) | Why/Notes |
|---|---|---|
| This repo (nixos-config) | `~/nixos-config` (incl. `flake.lock`) | Preserves exact versions and config history; push to remote or archive |
| Neovim config | `~/dev/neovim-config` | Actual editor config (repo symlinked by `modules/home/neovim.nix`) |
| Zoxide database | `${XDG_DATA_HOME:-~/.local/share}/zoxide/db` | Directory frecency learning |
| NBFC config | `~/.config/nbfc.json` | Required by `hosts/laptop/nbfc.nix` |
| SSH | `~/.ssh/` | Keys (`id_ed25519*`), `config`, `known_hosts`, `authorized_keys` |
| GPG (if used) | `~/.gnupg/` | Keys, trustdb; consider `gpg --export-secret-keys` |
| NetworkManager | `/etc/NetworkManager/system-connections/*.nmconnection` | Wi‑Fi, VPN, WireGuard profiles (may contain secrets) |
| WireGuard files (if not NM) | wherever saved (e.g., `~/wg/*.conf`) | Keep original `.conf` plus keys if separate |
| Docker data (if used) | `/var/lib/docker/volumes/` and bind mounts | Persistent container volumes and data dirs |

Notes on secrets: Treat SSH/GPG keys and WireGuard/NM exports as sensitive. Store with restricted permissions and never commit them to this repo.

Quick backup script (fish): See `docs/backup.fish`.

To run it:

```fish
fish docs/backup.fish
```

NetworkManager/WireGuard export (optional, may require sudo)

```fish
# Export all connection profiles to the backup directory
set -l BK "$HOME/backups/(date "+%Y-%m-%d_%H-%M-%S")"
mkdir -p $BK/nm
nmcli -t -f NAME connection show | while read -l name
  sudo nmcli connection export "$name" "$BK/nm/(string replace -a ' ' '_' $name).nmconnection"
end
echo "NM profiles exported to: $BK/nm"
```

Restoring is typically just copying files back into place (and for NM, importing with `nmcli connection import`). Always set correct permissions afterward (e.g., `chmod 600` for private keys and `.nmconnection` files containing secrets).
