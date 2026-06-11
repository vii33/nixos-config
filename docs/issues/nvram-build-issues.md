# NVRAM Build Issues & Workarounds

## Issue Description
The system experiences rebuild issues due to corrupted EFI NVRAM variables. This manifests as a failure during `nixos-rebuild switch`, particularly in the last step during bootloader installation.

## Hardware
- **Device:** Xiaomi Mi Air 13.3 inch (approx. 2017 model)

## Symptoms
- `nixos-rebuild switch` fails.
- `bootctl status` may crash or report errors.
- The issue persists even after resetting BIOS to "optimal settings".

## Attempted Solutions (Failed)
1. **BIOS Reset:** Resetting the BIOS to "optimal settings" did not resolve the issue.
2. **Automated Workaround Script:** 
   - The script `docs/nixos-rebuild-workaround.fish` was created to handle this.
   - **Status:** Fails.
   - **Error:** It cannot find the last generation correctly.

## Working Solution
The current reliable workaround involves manually cleaning up old generations before rebuilding.

### Steps:
1. Delete old generations (keeping the last 3):
   ```fish
   sudo nix-env --delete-generations +3 --profile /nix/var/nix/profiles/system
   ```
2. Collect garbage to free up space:
   ```fish
   sudo nix-collect-garbage 
   ```
3. Run the rebuild:
   ```fish
   sudo nixos-rebuild switch --flake .#laptop
   ```

## Related Configuration
In `hosts/laptop/configuration.nix`, the following settings are applied to mitigate NVRAM issues:
```nix
boot.loader.systemd-boot.graceful = true; # Ignore EFI variable errors
boot.loader.systemd-boot.configurationLimit = 10; # Limit boot entries to prevent ESP from filling up
boot.loader.efi.canTouchEfiVariables = false; # Disabled due to corrupted NVRAM
```

### Explanation
- **`graceful = true`**: Prevents the build from failing if `bootctl` returns an error status (common with corrupted NVRAM).
- **`canTouchEfiVariables = false`**: Forces NixOS to manage boot entries via files on the EFI partition (`/boot/loader/loader.conf`) instead of trying to write to the corrupted NVRAM.
- **`configurationLimit = 10`**: Automatically deletes older generations from the boot menu. This prevents the EFI partition from filling up, which was the likely cause of the build failures requiring manual generation deletion.
