---
applyTo: 'modules/**/*.nix'
---

# NixOS Modules Instructions

When working with files in `modules/`:

## Module layout in this repo

- `modules/system/` — system-level reusable modules (users, timezone, system services).
- `modules/home/` — Home Manager helper modules (alacritty, fish-shell, mouse, etc.).

Keep modules small, composable and documented. Prefer the shape `{ config, pkgs, ... }:` for reusable modules.

Modules are directly imported by hosts (in `hosts/`) without an intermediate profile layer.

## Best practices

- Comment hardware-specific or non-obvious configurations.
- Avoid hardcoding usernames or absolute paths; accept `specialArgs` and parameters where appropriate.
- Group related settings (e.g. services, users, packages) together for clarity.
- `modules/home/fish.nix`: Use clear text keyboard shortcuts and not escaped sequences.

## Testing

Test changes by rebuilding the host: `nixos-rebuild switch --flake .#<host>` (e.g. `.#laptop`, `.#work`).

```