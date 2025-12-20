# Platform-Specific Conditionals in Nix

## Using lib.optionals for Platform-Specific Imports

### All Imports Are Platform-Specific

When all imports should only apply to one platform:

```nix
{ config, pkgs, lib, pkgs-unstable, ... }:

{
  imports = lib.optionals pkgs.stdenv.isLinux [
    ../../modules/home/kde.nix
    ../../modules/home/onedriver.nix
    ../../modules/home/niri/niri.nix
    ../../modules/home/niri/waybar.nix
    ../../modules/home/niri/fuzzel.nix
    ../../modules/home/niri/mako.nix
  ];
}
```

### Mixed Common and Platform-Specific Imports

When you have both common and platform-specific imports:

```nix
{ config, pkgs, lib, pkgs-unstable, ... }:

{
  imports = [
    # Common imports for all platforms
    ../../modules/home/common.nix
    ../../modules/home/git.nix
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # Linux-only imports
    ../../modules/home/kde.nix
    ../../modules/home/niri/niri.nix
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # macOS-only imports
    ../../modules/home/macos-specific.nix
  ];
}
```

### Platform-Specific Packages

```nix
home.packages = with pkgs; [
  # Common packages
  brave
  obsidian
  bitwarden-desktop
] ++ lib.optionals stdenv.isLinux [
  # Linux-only packages
  vlc
  signal-desktop
] ++ lib.optionals stdenv.isDarwin [
  # macOS-only packages
  rectangle
];
```

## Alternative: if-then-else

For simple binary choices:

```nix
imports = [
  ../../modules/home/common.nix
] ++ (if pkgs.stdenv.isDarwin then [
  ../../modules/home/macos.nix
] else [
  ../../modules/home/linux.nix
]);
```

## Available Platform Checks

### Operating Systems
- `stdenv.isLinux` - Linux
- `stdenv.isDarwin` - macOS
- `stdenv.isFreeBSD` - FreeBSD
- `stdenv.isOpenBSD` - OpenBSD
- `stdenv.isNetBSD` - NetBSD
- `stdenv.isCygwin` - Cygwin on Windows
- `stdenv.isWindows` - Windows

### CPU Architectures
- `stdenv.isx86_64` - 64-bit Intel/AMD
- `stdenv.isAarch64` - 64-bit ARM (Apple Silicon, etc.)
- `stdenv.isAarch32` - 32-bit ARM
- `stdenv.isi686` - 32-bit Intel

### Combined Checks
- `stdenv.isUnix` - Any Unix-like system
- `stdenv.isBSD` - Any BSD variant

### Libc Variants
- `stdenv.isMusl` - musl libc
- `stdenv.isGnu` - GNU libc (glibc)

## Complex Conditions

Combine multiple checks:

```nix
lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
  # Linux ARM64-specific packages
  some-arm-package
]

lib.optionals (stdenv.isLinux && !stdenv.isMusl) [
  # Linux with glibc (not Alpine/musl)
  glibc-specific-package
]
```

## Best Practices

1. **Use `lib.optionals`** - More idiomatic than if-then-else for lists
2. **Prefer positive checks** - `isLinux` is clearer than `!isDarwin`
3. **Add `lib` to function arguments** - Required for `lib.optionals`
4. **Group related conditionals** - Keep platform-specific code together
5. **Comment your intentions** - Make it clear why something is platform-specific
