{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

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

  services.hermes-agent = {
    enable = true;
    container.enable = false;
    addToSystemPackages = true;
    environmentFiles = [ "/var/lib/hermes/provider.env" ];

    # Available to gateway tools and scheduled jobs, not only interactive shells.
    extraPackages = with pkgs; [
      python3
      uv
      nodejs
      bun
      git
      gh
      jq
      ripgrep
      pkgs-unstable.codex
      pkgs-unstable.opencode
      docker_29
      docker-compose
    ];
  };

  users.users.hermes.extraGroups = [
    "docker" # Allow Hermes to run containers on its dedicated VM.
  ];

  # Initial installation release; keep this static after installing the VM.
  system.stateVersion = "26.05";
}
