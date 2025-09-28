---
applyTo: 'flake.nix'
---

# Flake Configuration Instructions

This file is the main entry point for the NixOS flake configuration. When modifying:

## Structure Guidelines

1. **Inputs Section**: Only add well-maintained flake inputs
   - Pin to specific release branches for stability
   - Use `follows` to avoid input conflicts

2. **Outputs Section**: 
   - Keep `homeManagerModules` definitions clean and focused
   - Each host should have its own configuration in `nixosConfigurations`
   - Use `specialArgs` to pass flake inputs to modules

3. **System Definitions**:
   - `laptop` - Full desktop environment with NVIDIA, Home Manager
   - `home-server` - Minimal server configuration

## Common Modifications

- **Adding new hosts**: Create new entry in `nixosConfigurations`
- **Adding inputs**: Update both `inputs` and usage in modules
- **Home Manager changes**: Ensure backup settings are appropriate

## Testing

Use `nixos-rebuild switch --flake .#hostname` to test changes.