# NixOS Configuration 🌚🌠

Personal NixOS configuration using flakes and Home Manager.

## Repository Structure

- `flake.nix` - Main flake configuration defining system builds
- `hosts/` - Host-specific configurations
  - `laptop/` - Desktop/laptop configuration with NVIDIA support
  - `home-server/` - Headless server configuration
- `modules/` - Reusable NixOS modules
- `home/` - Home Manager user configurations

## Usage

### Building Configurations

```bash
# Build and switch laptop configuration
sudo nixos-rebuild switch --flake .#laptop

# Build home-server configuration  
sudo nixos-rebuild switch --flake .#home-server

# Test configuration without switching
sudo nixos-rebuild test --flake .#laptop
```

### Home Manager

Home Manager is integrated via flake configuration. User-specific settings are in `home/vii/`.

## Development

This repository includes comprehensive Copilot instructions in `.github/instructions/` to assist with:
- NixOS configuration best practices
- Repository structure guidance
- Host-specific configuration details
- Module development patterns

## Key Features

- **Flake-based**: Modern Nix flakes for reproducible configurations
- **Home Manager**: User environment management
- **Multi-host**: Support for laptop and server configurations
- **Hardware Support**: NVIDIA graphics, NBFC fan control
- **Shell Configuration**: Fish shell with Tide prompt
