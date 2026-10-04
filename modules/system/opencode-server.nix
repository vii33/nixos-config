# Starts opencode at startup
{
  config,
  pkgs,
  pkgs-unstable,
  serverUser,
  ...
}:

let
  userHome = config.home-manager.users.${serverUser}.home;
  opencodeServer = pkgs.writeScript "opencode-server" ''
    #!${pkgs.fish}/bin/fish --no-config
    set -gx OPENCODE_SERVER_PASSWORD \
      (string trim < "$CREDENTIALS_DIRECTORY/opencode_server_password")
    if test -z "$OPENCODE_SERVER_PASSWORD"
      echo "OPENCODE_SERVER_PASSWORD is empty; refusing to start OpenCode server." >&2
      exit 1
    end
    exec ${pkgs-unstable.opencode}/bin/opencode serve --hostname 0.0.0.0 --port 4096
  '';
in
{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    # Reuse the provisioned user identity, but decrypt at boot without a user login.
    age.keyFile = "${userHome.homeDirectory}/.config/sops/age/keys.txt";
    useSystemdActivation = true;
    secrets.opencode_server_password.restartUnits = [ "opencode-server.service" ];
  };

  systemd.services.opencode-server = {
    description = "OpenCode headless server";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    requires = [ "sops-install-secrets.service" ];
    after = [
      "network-online.target"
      "sops-install-secrets.service"
    ];
    # Give agent commands the same installed tools as the user's shell.
    path = [
      "/etc/profiles/per-user/${userHome.username}"
      "/run/current-system/sw"
    ];
    environment.HOME = userHome.homeDirectory;
    serviceConfig = {
      User = userHome.username;
      WorkingDirectory = userHome.homeDirectory;
      ExecStart = opencodeServer;
      # systemd reads the root-only SOPS file; the password never enters the Nix store.
      LoadCredential = [
        "opencode_server_password:${config.sops.secrets.opencode_server_password.path}"
      ];
      Restart = "on-failure";
      RestartSec = "5s";
      UMask = "0077"; # Keep newly created agent state private.
    };
  };
}
