# NixOS Configuration 🌚🌠

Personal NixOS configuration for multiple hosts, including MacOS.

## Key Features

This repo has two specialities: 
- First, it uses a simple modular architecture where hosts directly import reusable modules, enabling clean config organization across multiple machines.
- Second, it employs LazyVim for the Neovim setup, allowing quick customization of plugins and settings via lua files - without needing to rebuild your whole NixOS config each time you change a keyboard shortcut.

The laptop configuration includes **niri**, a scrollable-tiling Wayland compositor, available alongside KDE Plasma 6. You can test niri as an alternative session while keeping KDE as the default. See [docs/niri-testing-with-kde.md](docs/niri-testing-with-kde.md) for testing instructions or [docs/niri-setup.md](docs/niri-setup.md) for full details. 

## Modular Architecture

This a NixOS configuration repository designed for managing multiple hosts with a consistent setup. It is based on a simplified two-tier approach:

- **Modules** (reusable building blocks) — `modules/system/` and `modules/home/`
- **Hosts** (specific machines that directly import modules) — `hosts/laptop/`, `hosts/home-server/`, `hosts/work/`

Each host's `default.nix` file directly imports the modules it needs and inline the necessary configuration options.

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│ MODULES (Reusable Components)                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  System Modules:              Home Modules:                     │
│  ├─ niri.nix                  ├─ fish-shell.nix                 │
│  └─ ...                       ├─ kitty.nix                      │
│                               ├─ kitty-hm.nix                   │
│                               ├─ nixvim/lazyvim.nix             │
│                               ├─ niri/niri.nix                  │
│                               ├─ niri/waybar.nix                │
│                               └─ ...                            │
└─────────────────────────────────────────────────────────────────┘
                                ▲
                                │ imports
                                │
┌─────────────────────────────────────────────────────────────────┐
│ HOSTS (Specific Machines)                                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  hosts/laptop/default.nix                                       │
│  ├─ imports configuration.nix (laptop-specific settings)        │
│  ├─ imports hardware-configuration.nix (laptop hardware)        │
│  ├─ imports modules/system/niri.nix                             │
│  ├─ inline common system configuration                          │
│  ├─ inline Linux-specific configuration                         │
│  ├─ inline desktop & development configuration                  │
│  └─ imports swap.nix, nbfc.nix (laptop-specific services)       │
│                                                                 │
│  hosts/home-server/default.nix                                  │
│  ├─ imports configuration.nix (server-specific settings)        │
│  ├─ inline common system configuration                          │
│  └─ inline Linux-specific configuration                         │
│                                                                 │
│  hosts/work/default.nix (macOS with nix-darwin)                 │
│  ├─ imports configuration-nix-darwin.nix (macOS settings)       │
│  ├─ imports brew.nix (Homebrew packages)                        │
│  └─ inline common system configuration                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Keyboard Shortcuts

See [docs/shortcuts.md](docs/shortcuts.md) for a complete list of keyboard shortcuts and shell abbreviations for Fish shell, Kitty terminal, and FZF. Neovim/LazyVim-specific shortcuts (Outline, Harpoon2, Buffers, etc.) are in [docs/neovim-shortcuts.md](docs/neovim-shortcuts.md).



## Usage

### Building Configurations

#### NixOS Hosts (Linux)

```bash
# Build and switch laptop configuration
sudo nixos-rebuild switch --flake .#laptop

# Build home-server configuration  
sudo nixos-rebuild switch --flake .#home-server

# Test configuration without switching
sudo nixos-rebuild dry-run --flake .#laptop
```

#### macOS Host (nix-darwin)

##### Rebuild Commands
```bash
# Build and activate work configuration (standard method)
sudo env "PATH=$PATH" /run/current-system/sw/bin/darwin-rebuild switch --flake .#work

# Or build first, then activate separately:
darwin-rebuild build --flake .#work
sudo env "PATH=$PATH" ./result/activate

# Check configuration for errors (all hosts)
nix flake check

# Show what would change without building
darwin-rebuild check --flake .#work
```

**First-time setup:** The first time you set up nix-darwin on a new macOS system, follow these steps:

```bash
# 1. Create local-config.nix from the example and customize it:
cp local-config.nix.example local-config.nix
# Edit local-config.nix with your username

# 2. Make local-config.nix visible to the flake (without committing it):
git add --force --intent-to-add local-config.nix
# Hide it from git status to avoid accidentally staging it:
git update-index --assume-unchanged local-config.nix

# 3. Install Homebrew (if using brew.nix):
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Add brew to PATH (Apple Silicon):
eval "$(/opt/homebrew/bin/brew shellenv)"

# 4. Build the system configuration:
darwin-rebuild build --flake .#work

# 5. Activate with sudo (passing PATH for brew): -- not sure if this is needed, last time was a package bug
sudo env "PATH=$PATH" /run/current-system/sw/bin/darwin-rebuild switch --flake .#work

# 6. Open a new terminal window
```

After this, use the rebuild command above for future updates.

##### Nix Rebuild Commands
This is for first time setup and special cases where `darwin-rebuild` is not available.
```bash
nix build .#darwinConfigurations.work.activationPackage
sudo ./result/activate
```

##### Home Manager Commands
Home Manager just updates user-level managed packages, mostly dotfile configs.

```bash
# Update Home Manager configuration only (no sudo needed!)
home-manager --flake .#work switch

# This updates dotfiles (kitty, fish, etc.) without rebuilding the system
# Use this for quick user-level config changes
```

**Note:** For system-level changes (packages installed via nix-darwin, Homebrew apps, system settings), you still need to use `darwin-rebuild switch`.

##### Syncing LazyVim Plugin Specs (Manual LazyVim Setup)

If you're using manual LazyVim installation (with nixvim modules disabled), sync your plugin specs from the repo to your LazyVim config:

```bash
# Sync lua specs to ~/.config/nvim/lua/plugins/
fish modules/home/nixvim/sync-lazyvim-specs.fish

# Or from anywhere:
fish ~/repos/nixos-config/modules/home/nixvim/sync-lazyvim-specs.fish
```

This copies all `.lua` files from `modules/home/nixvim/lua-specs/` to `~/.config/nvim/lua/plugins/`, excluding:
- `init.lua` (only used for nix-managed setup)
- `mason-disabled.lua` (only needed on NixOS)

The script skips files that already exist, preserving any manual customizations you've made.

##### Reloading LaunchAgents

After running `home-manager switch`, some services (like key remapping) need to be reloaded:

```bash
# Reload Caps Lock → F18 key remapping
launchctl unload ~/Library/LaunchAgents/com.local.KeyRemapping.plist 2>/dev/null
launchctl load ~/Library/LaunchAgents/com.local.KeyRemapping.plist
```

**Checking if the service is running:**

```bash
# Check if service is loaded
launchctl list | grep KeyRemapping

# Check current key mappings
hidutil property --get "UserKeyMapping"

# View service details
launchctl print gui/$(id -u)/com.local.KeyRemapping

# Manually reapply mapping if needed
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006D}]}'
```

**Note:** The key remapping service automatically loads on login, so you only need to reload it manually after updating the configuration. The remapping requires Caps Lock to be enabled (not set to "No Action") in System Settings → Keyboard → Modifier Keys.

### Laptop Host: Bootloader Workaround (Corrupted NVRAM)

The laptop has corrupted EFI NVRAM variables that cause `bootctl status` to crash. If `nixos-rebuild switch` fails with `SIGABRT` during bootloader installation, use this workaround script:

```bash
sudo fish docs/nixos-rebuild-workaround.fish
```

This script:
1. Builds and activates the config using `nixos-rebuild test`
2. Sets it as the system profile
3. Manually creates the boot entry and updates the default

### Niri Window Manager (Optional)

The laptop has niri available as an alternative session alongside KDE. To test niri:

1. Log out of your current session
2. At the SDDM login screen, select "niri" from the session dropdown
3. Log in with your credentials
4. Use these basic shortcuts:
   - Press `Super + Return` to open a terminal
   - Press `Super + 1-9` to switch workspaces
   - See [docs/niri-shortcuts.md](docs/niri-shortcuts.md) for complete shortcuts
   
To switch back to KDE, log out and select "Plasma (Wayland)" or "Plasma (X11)" at the login screen.

For detailed testing instructions, see [docs/niri-testing-with-kde.md](docs/niri-testing-with-kde.md).

-----

## Manual Post-Install Steps

[docs/post-install-steps.md](docs/post-install-steps.md).

## Updating
[docs/updating.md](docs/updating.md).

## Future improvements – not yet automatic
- Move more pieces towards home-manager 
- Make NBFC JSON generation declarative (e.g. with a `home.file` entry gated by host)
- Declarative WireGuard interface(s)
- Automate swapfile creation & resume offset derivation (systemd tmpfiles + script)
- Introduce sops-nix or similar for secrets (VPN keys, etc.)

## Development

This repository includes comprehensive Copilot instructions in `.github/instructions/` to assist with:
- NixOS configuration best practices
- Repository structure guidance
- Host-specific configuration details
- Module development patterns

## Backups

[docs/backup.md](docs/backup.md).
