{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  userHome = config.home-manager.users.vii.home;
in
{
  boot = {
    growPartition = lib.mkDefault true;
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
  };

  fileSystems."/".autoResize = true; # Grow ext4 after increasing the VM disk size.

  networking = {
    hostName = "agent-host";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 4096 ]; # Allow password-authenticated OpenCode access from mobile.
  };

  services.openssh = {
    enable = true;
    openFirewall = true; # Allow remote administration of the VM.
  };
  services.qemuGuest.enable = lib.mkDefault true;

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    # Reuse the provisioned user identity, but decrypt at boot without a user login.
    age.keyFile = "${userHome.homeDirectory}/.config/sops/age/keys.txt";
    useSystemdActivation = true;
    secrets.synology-home-server-share-pw = { };
    templates."synology-home-server-share.credentials" = {
      mode = "0400"; # Only root can read the SMB credentials rendered at boot.
      content = ''
        username=agent-host-user
        password=${config.sops.placeholder.synology-home-server-share-pw}
      '';
    };
  };

  fileSystems."/mnt/home-server-share" = {
    device = "//192.168.0.200/home-server-share";
    fsType = "cifs";
    options = [
      "credentials=${config.sops.templates."synology-home-server-share.credentials".path}"
      "uid=${userHome.username}" # Map NAS files to the local agent user without pinning a UID.
      "gid=${config.users.users.${userHome.username}.group}"
      "nounix" # Use local ownership/modes rather than NAS-provided Unix permissions.
      "file_mode=0600" # Keep share access private to the local agent user.
      "dir_mode=0700"
      "nosuid" # Do not honor privilege bits or device nodes from the NAS.
      "nodev"
      "_netdev" # Wait for networking before attempting the boot mount.
      "nofail" # Keep the VM bootable when the NAS is unavailable.
      "x-systemd.mount-timeout=30s"
      "x-systemd.requires=sops-install-secrets.service" # Credentials must exist before mounting.
      "x-systemd.after=sops-install-secrets.service"
    ];
  };

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

  # Preserve the original home-server installation defaults on this cloned VM.
  system.stateVersion = "25.05";
}
