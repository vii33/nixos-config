# NixOS Configuration 🌚🌠

Personal flake-based NixOS/nix-darwin configuration for multiple hosts.

## Hosts

| Host | Platform | Entry point | Notes |
|---|---|---|---|
| `laptop` | NixOS/Linux | `hosts/laptop/default.nix` | NVIDIA laptop, KDE plus niri, desktop apps |
| `home-server` | NixOS/Linux | `hosts/home-server/default.nix` | Docker workloads and admin tools |
| `agent-host` | NixOS/Linux | `hosts/agent-host/default.nix` | Proxmox VM with Docker and Hermes gateway |
| `work` | nix-darwin/macOS | `hosts/work/default.nix` | Apple Silicon work laptop |

## Repo layout

- `flake.nix` wires inputs, host outputs, and standalone Home Manager outputs.
- `hosts/` contains host composition and host-local settings.
- `modules/system/` contains reusable system modules.
- `modules/home/` contains reusable Home Manager modules.
- `home/vii/` contains user-level Home Manager entry points.
- `secrets/` contains encrypted SOPS files only.

## Platform docs

- [Linux / NixOS hosts](docs/linux.md)
- [Agent host installation and Hermes setup](docs/agent-host.md)
- [Darwin / macOS host](docs/darwin.md)

## Common docs

- [Secrets](docs/secrets.md)
- [Keyboard shortcuts](docs/shortcuts.md)
- [Post-install steps](docs/post-install-steps.md)
- [Updating](docs/updating.md)
- [Backups](docs/backup.md)
- [Archived configuration snippets](docs/archive/README.md)
