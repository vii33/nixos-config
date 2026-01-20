# modules/home/darwin/flameshot.nix
# Flameshot screenshot tool with auto-start via launchd
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    flameshot
  ];

  # Auto-start Flameshot on login
  launchd.agents.flameshot = {
    enable = true;
    config = {
      ProgramArguments = [ "${pkgs.flameshot}/bin/flameshot" ];
      RunAtLoad = true;
      KeepAlive = false;
      ProcessType = "Interactive";
      Label = "org.flameshot.flameshot";
    };
  };
}
