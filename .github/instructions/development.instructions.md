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

Common patterns to avoid:
- Hardcoding absolute paths when relative paths are sufficient
- Mixing system-level and user-level configuration in the same file
- Editing auto-generated files (`hardware-configuration.nix`) except intentionally

## Safety Practices

1. Never commit secrets — use `secrets/` for templates only and keep real secrets out of the repo.
2. Test changes with `--dry-run` before switching.
3. Make small, incremental commits so rollbacks are easy.

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

