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

