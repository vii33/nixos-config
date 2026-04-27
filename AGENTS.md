# Agent Instructions — NixOS Configuration Repository

This is a personal, flake-based NixOS configuration repo. Primary user: `vii`.

## Repository Layout

```
flake.nix              # Entry point — nixpkgs pinned to nixos-25.05, matching Home Manager
hosts/
  laptop/              # Desktop/laptop — GUI, NVIDIA drivers, NBFC fan control
  home-server/         # Headless server (mockup for now)
  work/                # macOS nix-darwin — headless dev environment
modules/
  system/              # Shared system modules (users, timezone, services)
  home/                # Shared Home Manager modules (alacritty, fish, nixvim, …)
    nixvim/
      lazyvim.nix      # NixVim + LazyVim hybrid config
      lua-specs/       # Lua plugin specs injected into Neovim runtime
home/vii/              # Per-user Home Manager config
secrets/               # SOPS-encrypted secrets (Age-based)
docs/                  # Documentation (shortcuts.md, secrets.md, …)
```

### Per-host key files

| File | Purpose |
|---|---|
| `default.nix` | Host config — imports modules, inlines common settings |
| `configuration.nix` | Host-specific NixOS / nix-darwin configuration |
| `hardware-configuration.nix` | Auto-generated hardware detection (**do not edit** unless re-detected) |
| `home.nix` | Host-specific Home Manager entry for user packages |

## Code Style (`.nix` files)

- **2-space indentation**, lines ≤ 100 chars.
- Comment non-obvious choices and hardware tweaks.
- Group related attributes (services, users, packages).
- Keep modules small and composable; use `{ config, pkgs, ... }:` signatures.
- Don't hardcode usernames or absolute paths — use `specialArgs` / parameters.
- Don't mix system-level and user-level config in the same file.

## Cross-Platform Modules (NixOS + nix-darwin)

Use `lib.optionalAttrs` (not `lib.mkIf`) when an **option path might not exist** on a platform:

```nix
# Good — only adds the subtree on Linux
let
  isLinux = builtins.match ".*-linux" (builtins.currentSystem or "") != null;
in
{ /* cross-platform */ } // lib.optionalAttrs isLinux {
  environment.localBinInPath = true;
}
```

`lib.mkIf` is fine when the option exists on all target platforms.

## Flake (`flake.nix`)

- `nixpkgs` → `nixos-25.05`; Home Manager follows via `follows`.
- Hosts are `nixosConfigurations`: `laptop`, `home-server`, `work`.
- Wire new inputs via `specialArgs = { inherit inputs; }`.
- New hosts: add entry under `nixosConfigurations` + create `hosts/<name>/`.

## Hosts

| Host | Platform | Notes |
|---|---|---|
| `laptop` | NixOS (Linux) | NVIDIA GPU, NBFC fan control, full desktop |
| `home-server` | NixOS (Linux) | Minimal headless server (WIP) |
| `work` | nix-darwin (macOS) | MacOS M3 laptop |

### Modification guidelines

- Add shared config to `modules/system/` or `modules/home/` and import from `default.nix`.
- Host-specific services go in `configuration.nix`.
- User-level changes go in the host's `home.nix` or `home/vii/`.
- **Never** change `system.stateVersion` without an intentional upgrade plan.

## Modules (`modules/`)

- `modules/system/` — system-level (users, timezone, system services).
- `modules/home/` — Home Manager (alacritty, fish, mouse, nixvim, …).
- Modules are imported directly by hosts — no intermediate profile layer.

## Zellij

- Shared Zellij config lives in `modules/home/zellij.nix`.
- For layout work, prefer explicit `split_direction="Vertical"` / `"Horizontal"` on tabs and pane containers so pane placement stays predictable. Be aware: split=vertical is a left/right slip, and vice versa.
- `start_suspended` is a per-pane layout property, not a global Zellij config option. To avoid the `<ENTER> run` prompt, set `start_suspended=false` on command panes in the layout.

## Neovim / LazyVim (`modules/home/nixvim/`)

Hybrid approach: **NixVim** generates the base Neovim config (read-only `~/.config/nvim/`); **LazyVim** manages plugins dynamically.

- Lua spec files live in `modules/home/nixvim/lua-specs/` and are injected into the runtime path.
- **Laptop**: specs managed by Home Manager (read-only symlinks). Edit in this repo → rebuild.
- **Work (macOS)**: NixVim is disabled. Specs live directly in `~/.config/nvim/lua/plugins/` (writable). Back up to `lua-specs/` periodically.
- **LSPs are Nix-managed** (`programs.nixvim.lsp.servers`). Mason is present but disabled for auto-install. Don't use Mason for LSPs on NixOS.
- **File naming**: use `-config.lua` suffix to avoid colliding with plugin `require()` names (e.g. `render-markdown-config.lua`, **not** `render-markdown.lua`).
- Mason repo is `mason-org/mason.nvim` (not `williamboman/mason.nvim`).

## Fish Shell

Fish is the default shell. It **does not support heredocs**.

```fish
# Bad
cat > file.txt << 'EOF' ...

# Good
printf '%s\n' 'line 1' 'line 2' > file.txt
```

In `modules/home/fish.nix`: use **clear text** keyboard shortcuts, not escaped sequences.

## Secrets (SOPS + Age)

Secrets are SOPS-encrypted in `secrets/secrets.yaml`. Always run from repo root.

```bash
# Set a key (in-place)
env SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
  sops --set '["key_name"] "value"' -i secrets/secrets.yaml

# Validate
env SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
  sops decrypt --extract '["key_name"]' secrets/secrets.yaml
```

**Rules**: use `sops --set … -i` (not `sops set`), don't edit temp copies outside `secrets/`, don't redirect stdout back into the file.

## Rebuild Commands

```bash
# NixOS hosts
nixos-rebuild switch --flake .#laptop
nixos-rebuild switch --flake .#home-server

# macOS (work) — must use full path with sudo
darwin-rebuild build --flake .#work --impure
sudo env "PATH=$PATH" /run/current-system/sw/bin/darwin-rebuild switch --flake .#work

# Dry-run / check
nixos-rebuild --dry-run --flake .#<host>
nix flake check --no-build
```

## Verification

- Before handoff, run `nix flake check --no-build` for substantive changes in this repo.
- Tiny literal-only tweaks can skip `nix flake check --no-build`, for example changing an integer, RGB value, or other scalar setting without changing option paths, imports, structure, or platform conditionals.
- Before any `darwin-rebuild build --flake .#work --impure` or `darwin-rebuild switch --flake .#work`, ask the user first; macOS rebuilds take a long time.
- For `hosts/work/`, `home/vii/home-darwin.nix`, or shared Home Manager modules used on macOS, also run `darwin-rebuild build --flake .#work --impure` after user approval.
- For Linux host changes, run the narrowest relevant host check, for example `nixos-rebuild --dry-run --flake .#laptop` or `nixos-rebuild --dry-run --flake .#home-server`.
- For shared cross-platform modules, prefer `nix flake check --no-build` plus the relevant host build/dry-run for each affected platform.
- If a verification command cannot run, say exactly which command was skipped and why.

## Safety & Workflow

- Never commit real secrets — `secrets/` holds only encrypted files.
- Test with `--dry-run` before switching.
- Make small, incremental commits for easy rollbacks.
- When adding/modifying keyboard shortcuts (Fish, Kitty, Neovim), update `docs/shortcuts.md`.
