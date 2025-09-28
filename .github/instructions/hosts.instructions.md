---
applyTo: 'hosts/**/*.nix'
---

# Host-Specific Configuration Instructions

When working with files in the `hosts/` directory:

## Host Structure

- `laptop/` - Desktop/laptop configuration with GUI, NVIDIA drivers
- `home-server/` - Headless server configuration
- `work/` - Full desktop environment for WSL (Windows 11)

### Laptop-Specific Notes

- **NVIDIA Configuration**: Managed in `hosts/laptop/configuration.nix` and related modules.
- **NBFC Fan Control**: Helper is `hosts/laptop/nbfc.nix`; requires per-user `~/.config/nbfc.json` to actually run.
- **Power Management**: Laptop-specific power settings are kept near the laptop host files.

### Home Server Notes

- **Mockup Configuration**: This is just a mockup for now and will be fleshed out later

### Work-Specific Notes

- **WSL Environment**: Running NixOS inside Windows Subsystem for Linux
- **Full Desktop**: Complete desktop environment adapted for WSL
- **Windows Integration**: Configured for seamless Windows 11 integration

## Key Files

1. **composer.nix** - Host composer that imports modules and profiles
2. **configuration.nix** - Host-specific NixOS configuration
3. **hardware-configuration.nix** - Auto-generated hardware detection output (do not edit unless necessary)
4. **home.nix** - Host-specific Home Manager entry (used to wire user home configurations)


## Modification Guidelines

1. **Hardware Changes**: Only modify `hardware-configuration.nix` when hardware was re-detected and you know what you're changing.
2. **Service Configuration**: Add host-specific services in `configuration.nix` or split into `modules/system` and import from the composer.
3. **User Environment**: Use the host's `home.nix` and `home/<user>/` for per-user Home Manager changes.
4. **System State**: Keep `system.stateVersion` as-is unless planning an upgrade—update with care.

## Testing

Use `nixos-rebuild switch --flake .#hostname` where hostname is `laptop`, `home-server`, or `work`.