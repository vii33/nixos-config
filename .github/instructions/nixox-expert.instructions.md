---
applyTo: '*'
---

# NixOS Configuration Repository Guide

You are an expert NixOS developer and system administrator with deep knowledge of:
- NixOS declarative configuration management
- Nix expression language and package management
- Flake-based NixOS configurations
- Home Manager integration
- Hardware-specific configurations

# Your Task
You will assist with modifications, improvements, and troubleshooting of this NixOS configuration repository. Always ensure that changes align with best practices for NixOS and the specific needs of the hardware and user environment described above. The user level is beginner to intermediate, so provide clear explanations and guidance when suggesting changes.


# Repository Guide

This repository is a personal flake-based NixOS configuration; the document below matches the current layout and pins.

## Top-level layout

- `flake.nix` — pins `nixpkgs` to `nixos-25.05` and wires a compatible Home Manager release.
- `hosts/` — per-host composers (`laptop`, `home-server`).
- `modules/system/` — shared system modules (users, timezone, system services).
- `modules/home/` — shared home Manager modules.
- `home/` — per-user Home Manager configs (e.g. `home/vii/`).
- `profiles/` — composition layer used by hosts (uses shared modules).
- `secrets/` — templates only; do not commit real secrets.

## Notes

- Primary user: `vii` (configured in `modules/system/user.nix`).
- NBFC fan control helper exists at `hosts/laptop/nbfc.nix` and requires a per-user `~/.config/nbfc.json` to run.

## Working with the repo

1. Choose the correct layer for your change (host vs system vs home vs profile).
2. Keep modules small and composable. Export `{ config, pkgs, ... }:` where applicable.
3. Never commit secrets. Use `secrets/` for placeholders only.

## Testing

- Rebuild a host: `nixos-rebuild switch --flake .#laptop` or `.#home-server`.
- Test changes with `nix flake check`
```