{ config, pkgs, lib, ... }:

{
  # Create a launchd agent to auto-start AlDente on login
  launchd.agents.aldente = {
    enable = true;
    config = {
      ProgramArguments = [ "/Applications/AlDente.app/Contents/MacOS/AlDente" ];
      RunAtLoad = true;
      KeepAlive = false;
      ProcessType = "Interactive";
      Label = "com.user.aldente";
    };
  };
}
