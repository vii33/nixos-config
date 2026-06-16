{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:

{
  # Configure onedriver to automatically mount on login via systemd
  # Reference: https://github.com/jstaf/onedriver#multiple-drives-and-starting-onedrive-on-login-via-systemd

  home.packages = with pkgs; [
    pkgs-unstable.onedriver
  ];

  # Enable and start onedriver service on user login.
  systemd.user.services.onedriver-onedrive = {
    Unit = {
      Description = "OneDriver service for OneDrive";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/OneDrive";
      ExecStart = "${pkgs-unstable.onedriver}/bin/onedriver %h/OneDrive";
      Restart = "on-abnormal";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Notes:
  # - Use this systemd service to automatically mount OneDrive at ~/OneDrive
  # - To debug, run: journalctl --user -u onedriver-onedrive --since today
  # - To mount/unmount manually: systemctl --user start/stop onedriver-onedrive
}
