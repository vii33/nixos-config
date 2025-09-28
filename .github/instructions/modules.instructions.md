---
applyTo: 'modules/**/*.nix'
---

# NixOS Modules Instructions

When working with files in the `modules/` directory:

## Module Guidelines

1. **Structure**:
   - Each module should be self-contained and focused
   - Use proper Nix attribute sets and imports
   - Follow the existing pattern of `{ config, pkgs, ... }:`

2. **Key Modules**:
   - `default.nix` - System-wide packages and basic settings
   - `user.nix` - User accounts, locale, and timezone settings
   - `fish-shell.nix` - Fish shell system-level configuration
   - `home-manager/` - User-specific configurations

3. **Best Practices**:
   - Comment hardware-specific or complex configurations
   - Use consistent indentation (2 spaces)
   - Group related settings together
   - Avoid hardcoding user names where possible

## Common Modifications

- **Adding packages**: Use `environment.systemPackages` for system-wide packages
- **Service configuration**: Use `systemd.services` for custom services  
- **User settings**: Consider if changes belong in Home Manager instead

## Testing

Test module changes with `nixos-rebuild switch --flake .` after modifying system modules.