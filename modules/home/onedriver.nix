{ config, pkgs, ... }:

{
  # Configure onedriver to automatically mount on login via systemd
  # Reference: https://github.com/jstaf/onedriver#multiple-drives-and-starting-onedrive-on-login-via-systemd

  home.packages = with pkgs; [
    pkgs-unstable.onedriver
  ];

  # Create the mount point
  home.file."OneDrive/.keep".text = "";

  # Enable and start onedriver service on user login
  # The service name is derived from the mount point using systemd-escape
  # For ~/OneDrive, the service becomes: onedriver@home-vii-OneDrive.service
  systemd.user.services.onedriver-onedrive = {
    Unit = {
      Description = "OneDriver service for OneDrive";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "simple";
      # Mount point is ~/OneDrive, expand via systemd
      ExecStart = "${pkgs-unstable.onedriver}/bin/onedriver %h/OneDrive";
      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Notes on the mount point:
  # - onedriver will mount OneDrive at ~/OneDrive (symlink/directory)
  # - Use this systemd service to automatically mount on login
  # - To debug, run: journalctl --user -u onedriver-onedrive --since today
  # - To mount/unmount manually: systemctl --user start/stop onedriver-onedrive
}
