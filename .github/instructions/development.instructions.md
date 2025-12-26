---
applyTo: '*.nix'
---

# NixOS Development Best Practices

## Code Style

1. **Indentation**: Use 2 spaces consistently
2. **Line Length**: Keep lines under 100 characters when practical
3. **Comments**: Explain non-obvious choices and hardware tweaks
4. **Attribute Organization**: Group related attributes (services, users, packages)
5. Fish related aspects: `modules/home/fish.nix`: Use clear text keyboard shortcuts and not escaped sequences.

## Shell Commands (Fish)

The default shell is Fish, which **does not support heredocs**. When creating multi-line files:

**Bad:**
```fish
cat > file.txt << 'EOF'
content here
EOF
```

**Good:**
```fish
printf '%s\n' 'line 1' 'line 2' 'line 3' > file.txt
# or
echo 'line 1' > file.txt
echo 'line 2' >> file.txt
```

## Nix Expression Patterns (examples)

Good: clear attribute sets and imports, keep modules small and composable.

## Conditional Options: `lib.optionalAttrs` vs `lib.mkIf`

When writing cross-platform modules (NixOS + nix-darwin), **avoid referencing option paths that
don't exist** on one platform.

- Use `lib.mkIf` when the **option exists everywhere** you're evaluating the module, and you just
  want to enable/disable its value.
- Use `lib.optionalAttrs` (or `lib.mkMerge` + `lib.mkIf`) when the **option path may not exist** on
  some platforms. This prevents “The option `...` does not exist.” evaluation errors.

### Rule of thumb

If you are conditionally setting a whole option subtree (e.g. `virtualisation.*`,
`environment.localBinInPath`, `services.*`) and it might not exist on nix-darwin, **merge the attrs
only on the platform that supports them**.

### Examples

Bad (still fails on platforms where the option doesn't exist):

```nix
{
  # `environment.localBinInPath` is NixOS-only
  environment.localBinInPath = lib.mkIf pkgs.stdenv.isLinux true;
}
```

Good (only adds the option subtree when supported):

```nix
let
  # Avoid forcing `pkgs` during module argument resolution.
  isLinux = builtins.match ".*-linux" (builtins.currentSystem or "") != null;
in
{
  # ... normal cross-platform options here ...
} // lib.optionalAttrs isLinux {
  environment.localBinInPath = true;
  virtualisation.docker.enable = true;
}
```

Alternative (useful when you need multiple conditional chunks):

```nix
lib.mkMerge [
  {
    # cross-platform config
  }
  (lib.mkIf isLinux {
    # linux-only config (option paths must only exist on Linux)
  })
]
```

Common patterns to avoid:
- Hardcoding absolute paths when relative paths are sufficient
- Mixing system-level and user-level configuration in the same file
- Editing auto-generated files (`hardware-configuration.nix`) except intentionally

## Safety Practices

1. Never commit secrets — use `secrets/` for templates only and keep real secrets out of the repo.
2. Test changes with `--dry-run` before switching.
3. Make small, incremental commits so rollbacks are easy.

## macOS (nix-darwin) Rebuild Commands

**IMPORTANT**: When suggesting rebuild commands for macOS, ALWAYS use the full command with sudo and full path:

```bash
darwin-rebuild build --flake .#work
sudo env "PATH=$PATH" /run/current-system/sw/bin/darwin-rebuild switch --flake .#work
```

**NEVER** suggest just `darwin-rebuild switch --flake .#work` as it will fail with "command not found" when run with sudo.

## Debugging

- Use `nixos-rebuild --dry-run --flake .#<host>` to preview changes for a host (e.g. `.#work` for the WSL dev host).
- Inspect systemd logs with `journalctl -b` for runtime issues.
- Use `nix repl` to experiment with expressions and `nix flake show` to inspect outputs.

## Documentation

- **Keyboard Shortcuts**: When adding or modifying keyboard shortcuts (in Fish, Kitty, Neovim/LazyVim, etc.), always update `docs/shortcuts.md` to keep the documentation in sync.

## Neovim/Lua Configuration

- **File Naming**: Avoid naming Lua spec files exactly the same as the plugin module they configure. Do a `-config.lua`suffix instead.
  - **Bad**: `render-markdown.lua` (conflicts with `require("render-markdown")`)
  - **Good**: `render-markdown-config.lua`

