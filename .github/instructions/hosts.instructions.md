---
applyTo: 'hosts/**/*.nix'
---

# Host-Specific Configuration Instructions

When working with files in the `hosts/` directory:

## Host Structure

- `laptop/` - Desktop/laptop configuration with GUI, NVIDIA drivers
- `home-server/` - Headless server configuration

## Key Files

1. **composer.nix** - Main configuration composer that imports all modules
2. **configuration.nix** - Host-specific system settings
3. **hardware-configuration.nix** - Hardware detection results (auto-generated)
4. **home.nix** - Host-specific Home Manager settings

## Laptop-Specific Notes

- **NVIDIA Configuration**: Carefully modify graphics settings in configuration.nix
- **NBFC Fan Control**: Requires manual user configuration file at `~/.config/nbfc.json`
- **Power Management**: Configured for laptop-specific power saving

## Home Server Notes

- **Minimal Configuration**: Only essential services and packages
- **No GUI**: Headless configuration without display manager

## Modification Guidelines

1. **Hardware Changes**: Only modify hardware-configuration.nix if needed
2. **Service Configuration**: Add host-specific services to configuration.nix
3. **User Environment**: Use home.nix for host-specific user settings
4. **System State**: Maintain the stateVersion setting unless upgrading

## Testing

Use `nixos-rebuild switch --flake .#hostname` where hostname is `laptop` or `home-server`.