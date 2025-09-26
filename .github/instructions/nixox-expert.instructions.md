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

## Repository Structure

This is a personal NixOS configuration repository with the following structure:

- `flake.nix` - Main entry point defining system configurations and dependencies
- `hosts/` - Host-specific configurations (laptop, home-server)
  - `hosts/laptop/` - Laptop configuration with NVIDIA drivers, NBFC fan control
  - `hosts/home-server/` - Home server configuration
- `modules/` - Reusable NixOS modules
  - `modules/default.nix` - System-wide packages and basic configuration
  - `modules/user.nix` - User account and locale settings
  - `modules/fish-shell.nix` - Fish shell configuration with plugins
  - `modules/home-manager/` - Home Manager specific modules
- `home/` - User-specific Home Manager configurations
  - `home/vii/` - User 'vii' specific packages and settings

## Key Configuration Details

- **NixOS Version**: 25.05 (unstable channel)
- **User**: Primary user is 'vii'
- **Shell**: Fish shell with Tide prompt and various plugins
- **Hardware**: Laptop with NVIDIA graphics, fan control via NBFC
- **Locale**: German (de_DE.UTF-8) with English default
- **Package Management**: Flakes enabled with Home Manager integration

## Development Guidelines

### Making Changes

1. **Nix Expression Syntax**: Follow proper Nix syntax conventions
   - Use consistent indentation (2 spaces)
   - Prefer attribute sets over lists where appropriate
   - Comment complex expressions, especially hardware-specific configurations

2. **Configuration Organization**:
   - Keep host-specific settings in `hosts/` directories
   - Put reusable modules in `modules/`
   - User-specific packages go in `home/` directory
   - Use imports to compose configurations

3. **Testing Changes**:
   - Use `nixos-rebuild switch --flake .` to test system changes
   - Use `home-manager switch --flake .` for Home Manager changes
   - Always test on non-production systems first

4. **Hardware Considerations**:
   - NVIDIA configuration is in `hosts/laptop/configuration.nix`
   - NBFC fan control configuration requires user adjustment in `hosts/laptop/nbfc.nix`
   - Hardware-specific settings should remain in hardware-configuration.nix

### Code Quality

- **Comments**: Add explanatory comments for hardware-specific or complex configurations
- **Modularity**: Extract common patterns into reusable modules
- **Security**: Never commit sensitive information (passwords, keys, etc.)
- **Documentation**: Update README.md when adding significant features

### Common Tasks

- **Adding Packages**: Add to appropriate packages.nix file or environment.systemPackages
- **Service Configuration**: Use systemd.services for custom services
- **User Environment**: Modify Home Manager configurations for user-specific settings
- **Shell Configuration**: Fish shell settings are split between system-level and Home Manager
- **Restructuring**: Refactor configurations into modules for better maintainability

### Troubleshooting

- Check `flake.lock` for dependency versions
- Use `nix flake check` to validate flake syntax
- Review systemd logs for service issues
- NBFC requires manual configuration file creation in user home directory

## Assistance Guidelines

When helping with this repository:
1. Understand the modular structure before suggesting changes
2. Consider both system-level and user-level configuration impacts
3. Respect hardware-specific requirements (NVIDIA, fan control)
4. Maintain the existing organizational patterns
5. Test suggestions with proper NixOS rebuild commands

# Your Task
You will assist with modifications, improvements, and troubleshooting of this NixOS configuration repository. Always ensure that changes align with best practices for NixOS and the specific needs of the hardware and user environment described above. The user level is beginner to intermediate, so provide clear explanations and guidance when suggesting changes.