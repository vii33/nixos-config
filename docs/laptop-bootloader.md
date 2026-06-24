# Laptop Bootloader State

read_when: changing laptop bootloader, EFI, GRUB, Windows dual boot, or XBOOTLDR

## Current Known-Good Layout

Host: `laptop` / hostname `laptop2`.

The laptop uses GRUB as the active NixOS bootloader. Windows Boot Manager remains
installed and available as the second firmware entry.

Expected firmware state:

```text
BootCurrent: 0002
BootOrder: 0002,0000,...
Boot0002* NixOS-boot-efi -> \EFI\NixOS-boot-efi\grubx64.efi
Boot0000* Windows Boot Manager -> \EFI\Microsoft\Boot\bootmgfw.efi
```

Normal NixOS boot path:

```text
Firmware Boot0002
-> /boot/efi/EFI/NixOS-boot-efi/grubx64.efi
-> /boot/grub/grub.cfg
-> NixOS
```

Windows boot path:

```text
Firmware Boot0000
-> /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi
```

Fallback disk boot path:

```text
/boot/efi/EFI/BOOT/bootx64.efi
```

`/boot/efi/EFI/BOOT/bootx64.efi` was replaced with a copy of GRUB, so the
fallback path and the normal NixOS firmware entry use the same GRUB binary.

Verification hash after replacement:

```text
6fa6d0354987fb0152b667dd5f721c421863ea6865f1c6b22aa324932f839979  /boot/efi/EFI/NixOS-boot-efi/grubx64.efi
6fa6d0354987fb0152b667dd5f721c421863ea6865f1c6b22aa324932f839979  /boot/efi/EFI/BOOT/bootx64.efi
```

## NixOS Config

Relevant repo file: `hosts/laptop/configuration.nix`.

Expected bootloader config:

```nix
boot.loader.systemd-boot.enable = false;

boot.loader.grub = {
  enable = true;
  efiSupport = true;
  device = "nodev";
  useOSProber = true;
  configurationLimit = 10;
  copyKernels = true;
};

boot.loader.efi.canTouchEfiVariables = true;
boot.loader.efi.efiSysMountPoint = "/boot/efi";
```

Important mounted boot partitions:

```text
/boot      -> XBOOTLDR vfat partition
/boot/efi  -> ESP vfat partition
```

## Cleanup History

The machine previously had two NixOS bootloaders installed because the initial
dual-boot setup with Windows did not work correctly:

- GRUB: working, current active bootloader.
- systemd-boot: stale and not working.

The stale systemd-boot firmware entry was removed:

```bash
sudo efibootmgr -b 0001 -B
```

Removed firmware entry:

```text
Boot0001* Linux Boot Manager -> \EFI\systemd\systemd-bootx64.efi
```

After removal and reboot, `BootCurrent` remained `0002`, proving GRUB was the
active path.

Stale systemd-boot files were moved out of active paths, not deleted:

```text
/boot/efi/_removed-systemd-boot/loader
/boot/efi/_removed-systemd-boot/systemd
/boot/_removed-systemd-boot/loader
```

These backup folders can be deleted after a few successful reboots, once both
GRUB/NixOS and Windows boot are confirmed working. Keep them until then so the
cleanup remains easy to inspect and partially reversible.

The fallback EFI loader was changed from systemd-boot to GRUB:

```bash
sudo mkdir -p /boot/efi/_removed-systemd-boot/EFI-BOOT
sudo mv /boot/efi/EFI/BOOT/bootx64.efi \
  /boot/efi/_removed-systemd-boot/EFI-BOOT/bootx64.systemd-boot.efi
sudo cp /boot/efi/EFI/NixOS-boot-efi/grubx64.efi \
  /boot/efi/EFI/BOOT/bootx64.efi
```

## Verification Commands

Use these after bootloader changes:

```bash
efibootmgr -v
bootctl status --no-pager
sha256sum /boot/efi/EFI/NixOS-boot-efi/grubx64.efi /boot/efi/EFI/BOOT/bootx64.efi
```

Expected `bootctl` signal after cleanup:

```text
systemd-boot not installed in ESP.
```

`bootctl` may still inspect the ESP/XBOOTLDR layout, but it should not report
`/EFI/systemd/systemd-bootx64.efi` as installed.

## Do Not Touch Without a Recovery Plan

Keep these intact unless intentionally changing the bootloader:

- `/boot/efi/EFI/NixOS-boot-efi/grubx64.efi`
- `/boot/grub/`
- `/boot/kernels/`
- `/boot/efi/EFI/Microsoft/`
- firmware entry `Boot0002 NixOS-boot-efi`
- firmware entry `Boot0000 Windows Boot Manager`

Do not re-enable `boot.loader.systemd-boot` unless intentionally migrating away
from GRUB.

## Rollback Notes

If fallback `bootx64.efi` replacement ever needs to be undone and the backup is
still present:

```bash
sudo mv /boot/efi/EFI/BOOT/bootx64.efi \
  /boot/efi/EFI/BOOT/bootx64.grub-fallback.efi
sudo mv /boot/efi/_removed-systemd-boot/EFI-BOOT/bootx64.systemd-boot.efi \
  /boot/efi/EFI/BOOT/bootx64.efi
```

This only restores the fallback binary. It does not recreate the removed
systemd-boot firmware entry or its loader config.
