---
applyTo: 'hosts/**/*.nix'
---

# Host-Specific Configuration Instructions

When working with files in the `hosts/` directory:

## Host Structure

- `laptop/` - Desktop/laptop configuration with GUI, NVIDIA drivers
- `home-server/` - Headless server configuration
- `work/` - Headless WSL development environment (minimal, no desktop by default)

### Laptop-Specific Notes

- **NVIDIA Configuration**: Managed in `hosts/laptop/configuration.nix` and related modules.
- **NBFC Fan Control**: Helper is `hosts/laptop/nbfc.nix`; requires per-user `~/.config/nbfc.json` to actually run.
- **Power Management**: Laptop-specific power settings are kept near the laptop host files.

### Home Server Notes

- **Mockup Configuration**: This is just a mockup for now and will be fleshed out later

### Work-Specific Notes

- **macOS Environment**: Runs on macOS using nix-darwin; no bootloader or display manager.
- **Headless Dev Focus**: Imports common system configuration and development modules directly (no desktop by default).


## Key Files

1. **default.nix** - Host configuration that directly imports modules and inlines common configuration
2. **configuration.nix** - Host-specific NixOS/nix-darwin configuration
3. **hardware-configuration.nix** - Auto-generated hardware detection output (do not edit unless necessary)
4. **home.nix** - Host-specific Home Manager entry (used for host-specific user packages)


## Modification Guidelines

1. **Hardware Changes**: Only modify `hardware-configuration.nix` when hardware was re-detected and you know what you're changing.
2. **Service Configuration**: Add host-specific services in `configuration.nix` or split into `modules/system` and import from `default.nix`.
3. **User Environment**: Use the host's `home.nix` and `home/<user>/` for per-user Home Manager changes.
4. **System State**: Keep `system.stateVersion` as-is unless planning an upgrade—update with care.
5. **Common Configuration**: When adding configuration that should be shared across hosts, consider creating a module in `modules/system/` or `modules/home/` and importing it.

## Testing

Use `nixos-rebuild switch --flake .#hostname` where hostname is `laptop`, `home-server`, or `work`.