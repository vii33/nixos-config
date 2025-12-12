# Nix-darwin Migration Report

This report explains what in this repo can be reused on macOS with `nix-darwin` and what cannot, plus concrete migration steps and gotchas.

**Repository references**
- `flake.nix:1`
- `home/vii/home.nix:1`
- `home/vii/git.nix:1`
- `hosts/laptop/configuration.nix:1`
- `hosts/home-server/configuration.nix:1`
- `modules/home/nixvim/init.lua:1`
- `modules/system/niri.nix:1`

**Short summary**
- Reusable: user-level home-manager configs, editor/lua configs, package lists, flake structure (with edits).
- Partially reusable: nix expressions that declare packages or cross-platform modules — need system guards and `pkgs` for `darwin`.
- Not reusable: NixOS-only modules (systemd, kernel, bootloader, hardware configuration, many `modules/system/*`).

**What you can reuse (as-is or with minimal change)**
- Home-manager configurations and user dotfiles
  - `home/vii/home.nix:1` and `home/vii/git.nix:1` can be reused by enabling `home-manager` under `nix-darwin` or by using `home-manager`'s darwin integration.
- Per-user package lists and pkg overlays
  - Nix expressions that only build user packages (no systemd or Linux-only dependencies) are usually portable if `pkgs` is set to an `*-darwin` system.
- Neovim/Lua config and editor-specific modules
  - Files under `modules/home/nixvim/` (e.g. `modules/home/nixvim/init.lua:1`) are editor-level and reusable on macOS.
- Flake layout and development tooling
  - `flake.nix:1` and `flake.lock` provide a good starting structure; add `darwin` targets and `nix-darwin` inputs.

**What is partially reusable (needs adaptation)**
- Flake outputs and system-level nix expressions
  - `flake.nix` often defines `nixosConfigurations`; adapt to provide `darwinConfigurations` or a `darwin` branch and ensure `nixpkgs` is set to `x86_64-darwin` or `aarch64-darwin`.
- Module code that mixes Linux and generic settings
  - Some `modules/*` files define services or options that can be made conditional using `stdenv.isLinux` / `stdenv.isDarwin` or `lib.platforms` checks.
- Package overrides/overlays
  - Overlays that patch Linux-specific build flags or kernel headers will need darwin alternatives or conditional guards.

**What you cannot (or should not) reuse**
- Hardware-specific and NixOS-only files
  - `hosts/*/hardware-configuration.nix` (e.g. `hosts/laptop/hardware-configuration.nix:1`) is NixOS-only and irrelevant for macOS.
- System-level NixOS modules
  - `modules/system/*` (e.g. `modules/system/niri.nix:1`) which configure systemd services, kernel modules, swap, network interfaces, and bootloader settings do not apply to macOS and should be removed or guarded.
- Desktop environment and compositor configs that depend on Linux toolchains
  - KDE, Wayland, SDDM, systemd-networkd, and related settings in `profiles/system/*` are not usable on macOS.
- Low-level services and scripts that rely on `systemd` or Linux paths

**Concrete migration steps**
1. Add nix-darwin and darwin inputs to the flake
   - Update `flake.nix` to include `nix-darwin` and a `nixpkgs` pinned for `darwin` systems.
2. Create `darwinConfigurations` in the flake or add a `darwin/` host dir
   - Port per-machine `hosts/<name>/` into `darwinConfigurations.<host> = { ... }`.
3. Use `home-manager` on darwin
   - Reuse `home/vii/home.nix` by enabling `home-manager` through `nix-darwin`'s `programs.home-manager.enable = true;` or via `home-manager` flake integration.
4. Convert or remove NixOS-only modules
   - Audit `hosts/*` and `modules/system/*` for `systemd`, `boot.loader`, `fileSystems`, `hardware-configuration.nix`, and remove or guard them using `stdenv.isLinux` checks.
5. Switch `pkgs` system to darwin when building for macOS
   - Ensure `pkgs = import nixpkgs { system = "x86_64-darwin"; };` (or `aarch64-darwin`) in your darwin-specific entries.
6. Test iteratively with `darwin-rebuild switch --flake .#my-host`

**Practical examples and tips**
- Flake example snippet (concept):
  - set `inputs.darwin.url = "github:nix-darwin/nix-darwin";` and add `darwinConfigurations.<host>.system = ...` that imports your `home/*` flake outputs.
- Guarding linux-only code:
  - Wrap system-only imports: `imports = lib.optionals stdenv.isLinux [ ./modules/system/some-linux.nix ];`
- Reusing package lists:
  - Move common packages into a `packages/common.nix` and import it from both `nixosConfigurations` and `darwinConfigurations` with appropriate `pkgs`.

**Gotchas and macOS specifics**
- macOS does not use `systemd`; many service concepts differ (launchd, macOS services).
- Kernel modules and swap settings are meaningless on macOS.
- Some packages have different names/builds on darwin; check substituters and macOS-specific build flags.
- Homebrew-managed system libraries may be expected by some user code; prefer pure Nix packages where possible.
- If you use `nbfc.nix` or `swap.nix` in `hosts/laptop`, they are Linux-only.

**Next steps I can help with**
- Update `flake.nix` to add `nix-darwin` and a sample `darwinConfigurations` entry.
- Create a `darwin/` host configuration that reuses `home/vii/home.nix`.
- Audit `modules/system/*` and produce a minimal darwin-safe import list.

If you want, I can start by preparing a patched `flake.nix` and a `darwinConfigurations.<your-host>` that reuses your `home` config — tell me which Mac architecture you target (`x86_64-darwin` or `aarch64-darwin`).
