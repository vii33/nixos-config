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
    hostName = "home-server";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 4096 ]; # Allow password-authenticated OpenCode access from mobile.
  };

  services.openssh = {
    enable = true;
    openFirewall = true; # Allow remote administration of the VM.
  };

  services.qemuGuest.enable = lib.mkDefault true;
}
