{ config, pkgs, lib, ... }:

{
  # Configure onedriver to automatically mount on login via systemd
  # Reference: https://github.com/jstaf/onedriver#multiple-drives-and-starting-onedrive-on-login-via-systemd

  home.packages = with pkgs; [
    onedriver
  ];

  # Enable and start onedriver service on user login
  # The service will create the mount point at ~/OneDrive
  systemd.user.services.onedriver-onedrive = {
    Unit = {
      Description = "OneDriver service for OneDrive";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "simple";
      # Mount point is ~/OneDrive, expand via systemd
      ExecStart = "${pkgs.onedriver}/bin/onedriver %h/OneDrive";
      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Notes on the mount point:
  # - onedriver will create and mount OneDrive at ~/OneDrive
  # - Use this systemd service to automatically mount on login
  # - To debug, run: journalctl --user -u onedriver-onedrive --since today
  # - To mount/unmount manually: systemctl --user start/stop onedriver-onedrive
}
