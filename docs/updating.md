# Updating Packages Guide

This guide explains how to update packages in your NixOS configuration for both NixOS and nix-darwin hosts.

## Overview

This repository uses a flake-based configuration with:
- **nixpkgs**: Pinned to `nixos-25.05`
- **home-manager**: Release `25.05`
- **nix-darwin**: Release `nix-darwin-25.05`
- **nixvim**: Channel `nixos-25.05`
- **niri**: Tracks upstream flake

---

## Switching to a Newer NixOS/nixpkgs Branch

To switch from one release branch to another (e.g., from `25.05` to `25.11`), you need to update the input URLs in your `flake.nix`.

### Step 1: Edit flake.nix

Update the branch references in your [flake.nix](../flake.nix):

```nix
inputs = {
  # Change from nixos-25.05 to nixos-25.11
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  
  # Update home-manager to matching release
  home-manager = {
    url = "github:nix-community/home-manager/release-25.11";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  
  # Update nix-darwin to matching release (for macOS)
  nix-darwin = {
    url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  
  # Update nixvim to matching channel
  nixvim = {
    url = "github:nix-community/nixvim/nixos-25.11";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  
  # Keep unstable on latest (optional)
  nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  
  # niri tracks its own flake, no change needed
  niri = {
    url = "github:sodiboo/niri-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

### Step 2: Update Flake Lock

After editing `flake.nix`, update the lock file to fetch the new branches:

```bash
nix flake update
```

This will download the new channel and update all dependencies.

### Step 3: Apply Changes

**For NixOS hosts:**
```bash
sudo nixos-rebuild switch --flake .#laptop
# or
sudo nixos-rebuild switch --flake .#home-server
```

**For nix-darwin host:**
```bash
darwin-rebuild switch --flake .#work
```

### Step 4: Commit Changes

If everything works, commit the updated configuration:

```bash
git add flake.nix flake.lock
git commit -m "Update to NixOS 25.11"
```

### Important Notes

- **Breaking changes**: Major version updates may include breaking changes. Review the [NixOS release notes](https://nixos.org/manual/nixos/stable/release-notes.html).
- **Compatibility**: Ensure all inputs (home-manager, nix-darwin, nixvim) have compatible releases for your target version.
- **Testing**: Test on a non-critical system first, or use `nixos-rebuild test` before committing.
- **Rollback**: If issues occur, you can revert the `flake.nix` changes and run `nix flake update` again, or use `--rollback`.

### Switching to Unstable

For the latest packages (with less stability guarantees):

```nix
nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
```

Note: Not all inputs may have an `unstable` branch. Check their repositories for available branches.

---

## A) NixOS Hosts (laptop, home-server)

### Update Flake Inputs

Update all flake inputs (nixpkgs, home-manager, etc.) to their latest versions:

```bash
nix flake update
```

To update only specific inputs:

```bash
# Update only nixpkgs
nix flake lock --update-input nixpkgs

# Update only home-manager
nix flake lock --update-input home-manager

# Update unstable channel
nix flake lock --update-input nixpkgs-unstable
```

### Apply Updates to NixOS System

After updating flake inputs, rebuild your system:

```bash
# For laptop
sudo nixos-rebuild switch --flake .#laptop

# For home-server
sudo nixos-rebuild switch --flake .#home-server
```

### Test Before Applying

To test changes without making them permanent:

```bash
sudo nixos-rebuild test --flake .#laptop
```

To build without activating:

```bash
sudo nixos-rebuild build --flake .#laptop
```

### Update Home Manager Only

If you only changed Home Manager configuration:

```bash
home-manager switch --flake .#vii@laptop
# or
home-manager switch --flake .#vii@home-server
```

---

## B) nix-darwin Host (work)

The nix-darwin setup is more complex as it combines multiple package managers:
- **nix-darwin**: System configuration
- **Nix packages**: User and system packages via Nix
- **Homebrew**: GUI applications and macOS-specific tools
- **Home Manager**: User environment configuration

### 1. Update Nix Flake Inputs

Update all flake inputs (including nix-darwin, nixpkgs, home-manager):

```bash
nix flake update
```

Or update specific inputs:

```bash
# Update nix-darwin
nix flake lock --update-input nix-darwin

# Update nixpkgs
nix flake lock --update-input nixpkgs

# Update home-manager
nix flake lock --update-input home-manager
```

### 2. Apply nix-darwin System Updates

After updating flake inputs, rebuild your nix-darwin configuration:

```bash
darwin-rebuild switch --flake .#work
```

This will:
- Update nix-darwin system configuration
- Update Nix packages installed via nix-darwin
- Trigger Homebrew updates (if `homebrew.onActivation.autoUpdate = true`)
- Apply Home Manager changes

### 3. Update Home Manager Only

If you only changed Home Manager configuration without system changes:

```bash
home-manager switch --flake .#work
```

### 4. Update Homebrew Packages

Homebrew updates are handled in two ways:

#### Automatic Updates (Recommended)

Your configuration has `homebrew.onActivation.autoUpdate = true`, which means:
- Homebrew packages update automatically during `darwin-rebuild switch`

#### Manual Updates

If you need to manually update Homebrew:

```bash
# Update Homebrew itself
brew update

# Upgrade all installed packages
brew upgrade

# Upgrade specific package
brew upgrade <package-name>

# Upgrade casks (GUI apps)
brew upgrade --cask

# Upgrade specific cask
brew upgrade --cask <cask-name>
```

### 5. Update Nix Daemon and Nix Tools

To update the Nix package manager itself on macOS:

```bash
# Check current Nix version
nix --version

# Update Nix (handled by nix-darwin)
darwin-rebuild switch --flake .#work
```

The Nix daemon is managed by nix-darwin, so system rebuilds will update it as needed.

---

## Complete Update Workflow

### For NixOS Hosts

```bash
# 1. Update flake inputs
nix flake update

# 2. Check what will change
nix flake check

# 3. Rebuild system
sudo nixos-rebuild switch --flake .#laptop

# 4. Optional: Clean old generations
sudo nix-collect-garbage --delete-older-than 30d
```

### For nix-darwin Host (work)

```bash
# 1. Update flake inputs
nix flake update

# 2. Check what will change
nix flake check

# 3. Rebuild system (includes Homebrew auto-update)
darwin-rebuild switch --flake .#work

# 4. Optional: Manually verify Homebrew updates
brew outdated

# 5. Optional: Clean old generations
nix-collect-garbage --delete-older-than 30d

# 6. Optional: Clean Homebrew cache
brew cleanup
```

---

## Checking for Available Updates

### Check Flake Input Updates

See what updates are available without applying them:

```bash
nix flake metadata
```

Compare current lock file with latest available:

```bash
# Show what would be updated
nix flake lock --update-input nixpkgs --dry-run
```

### Check Homebrew Updates (macOS only)

```bash
# List outdated packages
brew outdated

# List outdated casks
brew outdated --cask
```

---

## Troubleshooting

### If nix-darwin rebuild fails

```bash
# Check for syntax errors
nix flake check

# Build without switching
darwin-rebuild build --flake .#work

# View detailed error messages
darwin-rebuild switch --flake .#work --show-trace
```

### If Homebrew conflicts occur

```bash
# Clean up Homebrew
brew cleanup

# Fix permissions
brew doctor

# Reinstall problematic package
brew reinstall <package-name>
```

### Rollback to Previous Generation

```bash
# For NixOS
sudo nixos-rebuild switch --rollback

# For nix-darwin
darwin-rebuild --rollback

# For Home Manager
home-manager generations
# Then select a generation to activate
/nix/store/<hash>-home-manager-generation/activate
```

---

## Best Practices

1. **Update regularly**: Run `nix flake update` weekly or monthly to stay current
2. **Test before committing**: Use `nixos-rebuild test` or `darwin-rebuild build` to verify changes
3. **Commit lock file**: Always commit `flake.lock` after successful updates
4. **Review changes**: Check `git diff flake.lock` to see what changed
5. **Clean old generations**: Periodically run garbage collection to free disk space
6. **Keep backups**: On critical systems, test updates in a VM first

---

## Quick Reference

| Task | NixOS | nix-darwin |
|------|-------|------------|
| Update all inputs | `nix flake update` | `nix flake update` |
| Rebuild system | `sudo nixos-rebuild switch --flake .#laptop` | `darwin-rebuild switch --flake .#work` |
| Update Home Manager | `home-manager switch --flake .#vii@laptop` | `home-manager switch --flake .#work` |
| Update Homebrew | N/A | Auto during rebuild or `brew upgrade` |
| Garbage collect | `sudo nix-collect-garbage -d` | `nix-collect-garbage -d` |
| Rollback | `sudo nixos-rebuild --rollback` | `darwin-rebuild --rollback` |
