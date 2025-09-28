---
applyTo: 'hosts/**/*.nix'
---

# Host-Specific Configuration Instructions

When working with files in the `hosts/` directory:

## Host Structure

- `laptop/` - Desktop/laptop configuration with GUI, NVIDIA drivers
- `home-server/` - Headless server configuration
- `work/` - Full desktop environment for WSL (Windows 11)

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

- **Mockup Configuration**: This is just a mockup for now and will be fleshed out later
- **No GUI**: Headless configuration without display manager

## Modification Guidelines

1. **Hardware Changes**: Only modify hardware-configuration.nix if needed
2. **Service Configuration**: Add host-specific services to configuration.nix
3. **User Environment**: Use home.nix for host-specific user settings
4. **System State**: Maintain the stateVersion setting unless upgrading

## Work-Specific Notes

- **WSL Environment**: Running NixOS inside Windows Subsystem for Linux
- **Full Desktop**: Complete desktop environment adapted for WSL
- **Windows Integration**: Configured for seamless Windows 11 integration

## Testing

Use `nixos-rebuild switch --flake .#hostname` where hostname is `laptop`, `home-server`, or `work`.