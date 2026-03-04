---
applyTo: 'flake.nix'
---

# Flake Configuration Instructions

This file is the main entry point for the NixOS flake configuration. When modifying:

## Structure Guidelines

1. **Inputs Section**: Prefer pinned, well-maintained flake inputs
   - This repo pins `nixpkgs` to `nixos-25.05` and uses a matching Home Manager release (see `flake.nix`).
   - Use `follows` to keep `home-manager` in sync with `nixpkgs`.

2. **Outputs Section**: 
   - Compose `nixosConfigurations` per-host (this repo exposes `laptop`, `home-server` and `work`).
   - Use `specialArgs = { inherit inputs; }` so modules can reference flake inputs.
   - Expose `homeConfigurations` for Home Manager per-user activation packages when useful.

3. **System Definitions**:
   - `laptop` - Desktop environment with NVIDIA and Home Manager wiring
   - `home-server` - Minimal server configuration
   - `work` - Headless WSL development environment (no GUI by default)

## Common Modifications

- **Adding new hosts**: Add a new entry under `nixosConfigurations` and create a `hosts/<name>/composer.nix`.
- **Adding inputs**: Add the input to `inputs` and wire it into modules via `specialArgs` or module imports.
- **Home Manager changes**: If you add home-manager modules, ensure they are referenced from `hosts/<host>/home.nix` or `home/<user>/home.nix` as needed.

## Testing

Use `nixos-rebuild switch --flake .#<host>` to apply changes for a given host (for example `.#laptop`).
```