# Agent Instructions

Personal flake-based NixOS/nix-darwin repo. Primary user: `vii`.

## Repo Shape

- `flake.nix`: entry point. Keep nixpkgs/HM/nix-darwin/NixVim releases aligned.
- Linux: `nixosConfigurations`: `laptop`, `home-server`.
- macOS: `darwinConfigurations`: `work`.
- Host composition: `hosts/<host>/default.nix`.
- Linux host config: `hosts/<host>/configuration.nix`.
- Darwin host config: `hosts/work/configuration-nix-darwin.nix`.
- User HM config: `home/vii/home-linux.nix`, `home/vii/home-darwin.nix`.
- Shared modules: `modules/system/`, `modules/home/`.
- Do not edit `hardware-configuration.nix` unless hardware was re-detected.

## Nix Style

- 2-space indent, lines <= 100 chars.
- Comment only non-obvious choices/hardware tweaks.
- Group related attributes (services, users, packages).
- Small composable modules; use `{ config, pkgs, ... }:` signatures.
- Avoid hardcoded usernames/absolute paths; use `specialArgs`/params.
- Keep system config and user config separate.

## Cross-Platform

Use `lib.optionalAttrs` when an option path may not exist on a platform:

```nix
let
  isLinux = builtins.match ".*-linux" (builtins.currentSystem or "") != null;
in
{ /* cross-platform */ } // lib.optionalAttrs isLinux {
  environment.localBinInPath = true;
}
```

`lib.mkIf` is fine only when the option exists on all target platforms.

## Flake

- Wire new inputs via `specialArgs = { inherit inputs; }`.
- Local `builtins.getFlake "git+file://$PWD"` eval probes need `--impure`
  because the working tree flake reference is unlocked.
- New Linux host: `nixosConfigurations` + `hosts/<name>/`.
- New macOS host: `darwinConfigurations` + `hosts/<name>/`.

## Hosts

| Host | Platform | Notes |
|---|---|---|
| `laptop` | NixOS (Linux) | NVIDIA GPU, NBFC fan control, full desktop |
| `home-server` | NixOS (Linux) | Minimal headless server (WIP) |
| `work` | nix-darwin (macOS) | macOS M3 laptop |

### Edits

- Add shared config to `modules/system/` or `modules/home/` and import from `default.nix`.
- Host-specific services: host config file.
- User-level changes: `home/vii/` or `modules/home/`.
- Never change `system.stateVersion` without upgrade plan.

## Zellij

- Config: `modules/home/zellij.nix`.
- Layouts: use explicit `split_direction="Vertical"` / `"Horizontal"`.
- Zellij split=vertical means left/right, and vice versa.
- `start_suspended` is per-pane, not global. For command panes use
  `start_suspended=false` to avoid `<ENTER> run`.

## Neovim / LazyVim (`modules/home/nixvim/`)

Hybrid: NixVim base config, LazyVim dynamic plugins.

- Lua specs: `modules/home/nixvim/lua-specs/`, injected into runtime path.
- Laptop: specs HM-managed/read-only. Edit repo, rebuild.
- Work/macOS: NixVim disabled. Specs writable in `~/.config/nvim/lua/plugins/`.
  Back up to `lua-specs/`.
- LSPs are Nix-managed: `programs.nixvim.lsp.servers`. Do not use Mason for LSPs.
- Lua spec files: use `-config.lua` suffix to avoid plugin `require()` collisions.
- Mason repo is `mason-org/mason.nvim` (not `williamboman/mason.nvim`).

## Fish

- Default shell is fish. No heredocs.
- In `modules/home/fish-shell.nix`, use clear text shortcuts, not escapes.

```fish
printf '%s\n' 'line 1' 'line 2' > file.txt
```

## Secrets (SOPS + Age)

Secrets: SOPS Age in `secrets/secrets.yaml`. Run from repo root.

```bash
env SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
  sops --set '["key_name"] "value"' -i secrets/secrets.yaml

env SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
  sops decrypt --extract '["key_name"]' secrets/secrets.yaml
```

Use `sops --set ... -i`, not `sops set`. Do not edit temp copies outside
`secrets/`. Do not redirect stdout back into the file.

## Build Commands

```bash
# Verification
nixos-rebuild --dry-run --flake .#<host>
# Ask before running this; macOS builds take a long time.
darwin-rebuild build --flake .#work --impure
nix flake check --no-build

# Activation, only when intentionally switching
nixos-rebuild switch --flake .#<host>
sudo env "PATH=$PATH" /run/current-system/sw/bin/darwin-rebuild switch --flake .#work
```

## Verification

- After `.nix` edits: `nix fmt`.
- Substantive changes: `nix flake check --no-build`.
- Tiny scalar-only tweaks may skip flake check.
- Ask before Darwin build/switch; slow.
- macOS paths/modules: after approval, run `darwin-rebuild build --flake .#work --impure`.
- Linux host edits: narrow dry-run, e.g. `.#laptop` or `.#home-server`.
- Cross-platform shared modules: flake check + relevant host checks.
- If skipped/cannot run, say command and why.

## Safety & Workflow

- Never commit real secrets. `secrets/` holds encrypted files only.
- Test with `--dry-run` before switching.
- Make small, incremental commits for easy rollbacks.
- Keyboard shortcuts changed? Update `docs/shortcuts.md`.
