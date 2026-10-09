{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  serverUser,
  ...
}:

let
  userHome = config.home-manager.users.${serverUser}.home;
  hermes = config.services.hermes-agent;
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

  environment.systemPackages = [
    pkgs.ghostty.terminfo # Recognize xterm-ghostty in SSH sessions, including service administration.
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    # Reuse the provisioned user identity, but decrypt at boot without a user login.
    age.keyFile = "${userHome.homeDirectory}/.config/sops/age/keys.txt";
    age.sshKeyPaths = [ ]; # Use only the provisioned age identity for these secrets.
    gnupg.sshKeyPaths = [ ];
    useSystemdActivation = true;
    secrets = {
      synology-home-server-share-pw = { };
      HERMES_TELEGRAM_BOT_TOKEN = { };
      HERMES_TELEGRAM_ALLOWED_USERS = { };
    };
    templates."synology-home-server-share.credentials" = {
      mode = "0400"; # Only root can read the SMB credentials rendered at boot.
      content = ''
        username=agent-host-user
        password=${config.sops.placeholder.synology-home-server-share-pw}
      '';
    };
    templates."hermes-telegram.env" = {
      # Link the runtime dotenv directly: SOPS runs after Hermes's activation script.
      path = "${hermes.stateDir}/.hermes/.env";
      owner = hermes.user;
      group = hermes.group;
      mode = "0400"; # Only the Hermes service account and root can read Telegram credentials.
      restartUnits = [ "hermes-agent.service" ];
      content = ''
        TELEGRAM_BOT_TOKEN=${config.sops.placeholder.HERMES_TELEGRAM_BOT_TOKEN}
        TELEGRAM_ALLOWED_USERS=${config.sops.placeholder.HERMES_TELEGRAM_ALLOWED_USERS}
      '';
    };
  };

  fileSystems."/mnt/home-server-share" = {
    device = "//192.168.0.200/home-server-share";
    fsType = "cifs";
    options = [
      "credentials=${config.sops.templates."synology-home-server-share.credentials".path}"
      "uid=${userHome.username}" # Map NAS files to the local agent user without pinning a UID.
      "gid=home-server-share"
      "nounix" # Use local ownership/modes rather than NAS-provided Unix permissions.
      "file_mode=0660" # Allow the local agent user and Hermes to share read/write access.
      "dir_mode=0770"
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
    settings.model = {
      provider = "openai-codex";
      default = "gpt-6.1-sol";
    };

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

  systemd.services.hermes-agent = {
    requires = [ "sops-install-secrets.service" ]; # Do not start without the runtime dotenv.
    after = [ "sops-install-secrets.service" ];
    # Exempt the local parent so sandbox setup never probes an offline SMB mount.
    serviceConfig.ReadWritePaths = [ "/mnt" ];
  };

  users.groups.home-server-share = { }; # Limit local SMB access to the two agent accounts.
  users.users = {
    ${serverUser}.extraGroups = [
      "home-server-share" # Share NAS files with Hermes.
    ];
    hermes.extraGroups = [
      "docker" # Allow Hermes to run containers on its dedicated VM.
      "home-server-share" # Allow Hermes to read and write the SMB mount.
    ];
  };

  # Preserve the original home-server installation defaults on this cloned VM.
  system.stateVersion = "25.05";
}
