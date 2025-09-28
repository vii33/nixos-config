---
applyTo: '*.nix'
---

# NixOS Development Best Practices

## Code Style

1. **Indentation**: Use 2 spaces consistently
2. **Line Length**: Keep lines under 100 characters when possible
3. **Comments**: Add explanatory comments for complex configurations
4. **Attribute Organization**: Group related attributes together

## Nix Expression Patterns

```nix
# Good: Clear attribute set structure
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };
}

# Good: Proper imports structure
{
  imports = [
    ./module1.nix
    ./module2.nix
  ];
}

# Good: Package lists with comments
environment.systemPackages = with pkgs; [
  vim       # Text editor
  htop      # Process monitor
  git       # Version control
];
```

## Common Patterns to Avoid

- Hardcoding absolute paths when relative paths work
- Mixing system-level and user-level configurations inappropriately
- Adding packages without considering if they belong in Home Manager
- Modifying auto-generated files like hardware-configuration.nix unnecessarily

## Safety Practices

1. **Never commit secrets** - Use proper secret management
2. **Test before deployment** - Always test on non-production systems
3. **Backup configurations** - Keep working configurations backed up
4. **Incremental changes** - Make small, testable changes

## Debugging

- Use `nixos-rebuild --dry-run` to preview changes
- Check logs with `journalctl` for service issues
- Use `nix-store --query --tree` to inspect dependencies
- Leverage `nix repl` for expression testing