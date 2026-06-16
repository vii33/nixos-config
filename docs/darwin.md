# Darwin / macOS host

## Host

- `work`: Apple Silicon nix-darwin host.

## Rebuild commands

```bash
# Build and activate the system configuration
sudo env "PATH=$PATH" /run/current-system/sw/bin/darwin-rebuild switch --flake .#work

# Build first, activate separately
darwin-rebuild build --flake .#work --impure
sudo env "PATH=$PATH" ./result/activate

# Check flake outputs without building
nix flake check --no-build
```

## First-time setup

```bash
# Optional: set the macOS username explicitly
export MACOS_USERNAME="your-macos-username"

# Install Homebrew if using hosts/work/brew.nix
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Build and activate
darwin-rebuild build --flake .#work --impure
sudo env "PATH=$PATH" /run/current-system/sw/bin/darwin-rebuild switch --flake .#work
```

## Home Manager only

Use this for user-level dotfile changes that do not need a full nix-darwin rebuild:

```bash
home-manager --flake .#work switch --impure
```

## GitHub Desktop and `~/.gitconfig`

Home Manager keeps the declarative Git config in `~/.config/git/config`, while GUI tools
such as GitHub Desktop may still write legacy global settings to `~/.gitconfig`.

The shared Git module keeps `~/.gitconfig` writable and adds an include for the Home
Manager-managed config. If GitHub Desktop reports a lock or permission error, rebuild and
verify:

```bash
cd ~/repos/nixos-config
sudo env "PATH=$PATH" /run/current-system/sw/bin/darwin-rebuild switch --flake .#work
git config --global --list --show-origin
```

## DockDoor settings backup

DockDoor stores settings in:

```bash
~/Library/Preferences/com.ethanbills.DockDoor.plist
```

Back up or restore with:

```bash
cp ~/Library/Preferences/com.ethanbills.DockDoor.plist ~/Downloads/DockDoor-settings-backup.plist
defaults export com.ethanbills.DockDoor ~/Downloads/DockDoor-settings-backup.plist
defaults import com.ethanbills.DockDoor ~/Downloads/DockDoor-settings-backup.plist
```

## LazyVim plugin specs

When using manual LazyVim instead of NixVim on macOS, sync plugin specs with:

```bash
fish modules/home/nixvim/sync-lazyvim-specs.fish
```

The script copies Lua specs from `modules/home/nixvim/lua-specs/` while preserving
existing local customizations.

## Zellij config reloads

Zellij does not hot-reload config. After a Home Manager rebuild, use:

```bash
hmswitch
zz
```

## Reloading LaunchAgents

Some Home Manager services, such as key remapping, may need a manual reload after changes:

```bash
launchctl unload ~/Library/LaunchAgents/com.local.KeyRemapping.plist 2>/dev/null
launchctl load ~/Library/LaunchAgents/com.local.KeyRemapping.plist
```
