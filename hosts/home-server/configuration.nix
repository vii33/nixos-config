{ lib, ... }:

{
  boot = {
    growPartition = lib.mkDefault true;
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  services.qemuGuest.enable = lib.mkDefault true;
}
