{
  config,
  pkgs,
  serverUser,
  ...
}:

let
  profileDirectory = config.home-manager.users.${serverUser}.home.profileDirectory;
  desktopSession = pkgs.writeShellApplication {
    name = "server-desktop";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.dbus
      pkgs.icewm
      pkgs.tigervnc
      pkgs.xdpyinfo
    ];
    text = ''
      export PATH="${profileDirectory}/bin:/run/current-system/sw/bin:$PATH"
      Xvnc :1 -geometry 1600x1000 -depth 24 -rfbport 5901 \
        -localhost yes -SecurityTypes None -AlwaysShared -nolisten tcp &
      vnc_pid=$!
      wm_pid=""
      trap 'kill "$vnc_pid" ''${wm_pid:+"$wm_pid"} 2>/dev/null || true' EXIT

      ready=false
      for _ in $(seq 1 100); do
        if xdpyinfo -display :1 >/dev/null 2>&1; then
          ready=true
          break
        fi
        kill -0 "$vnc_pid"
        sleep 0.1
      done
      if [ "$ready" != true ]; then
        echo "Virtual desktop did not become ready" >&2
        exit 1
      fi

      dbus-run-session -- icewm-session &
      wm_pid=$!
      wait -n "$vnc_pid" "$wm_pid"
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    icewm
    tigervnc # Virtual X server and VNC client for headless desktop access.
    xterm
    xdotool # Let agents control windows and send keyboard/mouse input.
    imagemagick # Capture the virtual display for UI inspection.
    xdpyinfo # Inspect the virtual X display and check readiness.
  ];
  fonts.packages = [ pkgs.dejavu_fonts ]; # Basic UI fonts without a full desktop environment.
  systemd.tmpfiles.rules = [
    "d /tmp/.X11-unix 1777 root root -" # X servers need a root-owned socket directory.
  ];

  users.users.${serverUser}.linger = true; # Keep the desktop running without an SSH login.

  home-manager.users.${serverUser}.systemd.user.services.server-desktop = {
    Unit = {
      Description = "Headless IceWM desktop (VNC over SSH)";
      StartLimitIntervalSec = 60;
      StartLimitBurst = 5;
    };
    Service = {
      ExecStart = "${desktopSession}/bin/server-desktop";
      Environment = [ "DISPLAY=:1" ];
      Restart = "always";
      RestartSec = 5;
      KillMode = "control-group";
      UMask = "0077"; # Keep session-created files private to the desktop user.
    };
    Install.WantedBy = [ "default.target" ];
  };
}
