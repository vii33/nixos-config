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
    hostName = "agent-host";
    networkmanager.enable = true;
  };

  services.openssh = {
    enable = true;
    openFirewall = true; # Allow remote administration of the VM.
  };
  services.qemuGuest.enable = lib.mkDefault true;

  # Official Hermes image: configuration and credentials are set up at runtime.
  virtualisation.oci-containers = {
    backend = "docker";
    containers.hermes = {
      image = "nousresearch/hermes-agent:stable";
      autoStart = true;
      cmd = [ "gateway" "run" ];
      volumes = [ "/var/lib/hermes:/opt/data" ];
    };
  };

  # The image initializes ownership for its runtime user on first startup.
  systemd.tmpfiles.rules = [ "d /var/lib/hermes 0700 root root -" ];
  systemd.services.docker-hermes.unitConfig.ConditionPathExists = "/var/lib/hermes/config.yaml";

  # Initial installation release; keep this static after installing the VM.
  system.stateVersion = "26.05";
}
