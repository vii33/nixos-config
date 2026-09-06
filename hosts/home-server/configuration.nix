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

  services.openssh = {
    enable = true;
    openFirewall = true; # Allow remote administration of the VM.
  };

  services.qemuGuest.enable = lib.mkDefault true;
}
