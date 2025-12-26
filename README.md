# NixOS Configuration 🌚🌠

Personal NixOS configuration for multiple hosts, including MacOS.

## Key Features

This repo has two specialities: 
- First, it uses a modular architecture to enable config reuse across multiple hosts (see next section).
- Second, it employs LazyVim for the Neovim setup, allowing quick customization of plugins and settings via lua files - without needing to rebuild your whole NixOS config each time you change a keyboard shortcut.

The laptop configuration includes **niri**, a scrollable-tiling Wayland compositor, available alongside KDE Plasma 6. You can test niri as an alternative session while keeping KDE as the default. See [docs/niri-testing-with-kde.md](docs/niri-testing-with-kde.md) for testing instructions or [docs/niri-setup.md](docs/niri-setup.md) for full details. 

## Modular Architecture
This a NixOS configuration repository designed for managing multiple hosts with a consistent setup. It is based on three tiers:

- **Modules** (reusable building blocks) — `modules/system/` and `modules/home/`
- **Profiles** (compositions of modules for defined use cases) — `profiles/system/` and `profiles/home/`
- **Hosts** (specific machines with assigned profiles) — `hosts/laptop/`, `hosts/home-server/`, etc.

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│ MODULES (Reusable Components)                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  System Modules:              Home Modules:                     │
│  ├─ user.nix                  ├─ fish-shell.nix                 │
│  └─ ...                       ├─ kitty.nix                      │
│                               ├─ mouse.nix                      │
│                               ├─ nixvim/lazyvim.nix             │
│                               └─ ...                            │
└─────────────────────────────────────────────────────────────────┘
                                ▲
                                │ imports
                                │
┌─────────────────────────────────────────────────────────────────┐
│ PROFILES (Use Cases)                                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  System Profiles:             Home Profiles:                    │
│  ├─ common.nix                ├─ desktop.nix                    │
│  ├─ desktop.nix               └─ development-desktop.nix        │
│  ├─ development-headless.nix                                    │
│  └─ server.nix                                                  │
│                                                                 │
│  Example: "laptop" needs common + desktop + development         │
│           "home-server" needs common only                       │
└─────────────────────────────────────────────────────────────────┘
                                ▲
                                │ imports
                                │
┌─────────────────────────────────────────────────────────────────┐
│ HOSTS (Specific Machines)                                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  hosts/laptop/default.nix                                       │
│  ├─ imports common.nix                                          │
│  ├─ imports user.nix                                            │
│  ├─ imports configuration.nix (laptop-specific)                 │
│  ├─ imports desktop.nix                                         │
│  ├─ imports development-headless.nix                            │
│  ├─ imports hardware-configuration.nix (laptop hardware)        │
│  └─ imports swap.nix, nbfc.nix (laptop-specific services)       │
│                                                                 │
│  hosts/home-server/default.nix                                  │
│  ├─ imports common.nix                                          │
│  ├─ imports user.nix                                            │
│  ├─ imports configuration.nix (server-specific)                 │
│  └─ imports server.nix                                          │
│                                                                 │
│  hosts/work/default.nix (macOS with nix-darwin)                 │
│  ├─ imports common.nix                                          │
│  ├─ imports user.nix                                            │
│  ├─ imports configuration.nix (work-specific)                   │
│  ├─ imports configuration-nix-darwin.nix                        │
│  └─ imports development-headless.nix                            │
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
# 1. Install Homebrew (if using brew.nix):
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Add brew to PATH (Apple Silicon):
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Build the system configuration:
darwin-rebuild build --flake .#work

# 3. Activate with sudo (passing PATH for brew): -- not sure if this is needed, last time was a package bug
sudo env "PATH=$PATH" /run/current-system/sw/bin/darwin-rebuild switch --flake .#work

# 4. Open a new terminal window
```

After this, use the rebuild command above for future updates.

##### Nix Rebuild Commands
This is for first time setup and special cases where `darwin-rebuild` is not available.
```bash
nix build .#darwinConfigurations.work.activationPackage
sudo ./result/activate
```

##### Home Manager Commands
Home manager just updates user lavel managed packages, mostly dotfile configs. Home brew needs to be activated via nix build commands. 

First time setup to get Home Manager into PATH:
```bash
nix profile install "github:nix-community/home-manager/release-25.05#home-manager"
```

After this, update Home Manager configuration with:
```bash
home-manager --flake .#work switch  # not yet tested!
```

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
