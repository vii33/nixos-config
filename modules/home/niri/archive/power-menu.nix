# modules/home/niri/power-menu.nix
# Power management desktop entries for fuzzel
{ config, pkgs, ... }:

{
  xdg.desktopEntries = {
    power-shutdown = {
      name = "Power: Shutdown";
      comment = "Shut down the system";
      exec = "systemctl poweroff";
      icon = "system-shutdown";
      type = "Application";
      categories = [ "System" ];
      noDisplay = false;
    };

    power-restart = {
      name = "Power: Restart";
      comment = "Restart the system";
      exec = "systemctl reboot";
      icon = "system-reboot";
      type = "Application";
      categories = [ "System" ];
      noDisplay = false;
    };

    power-suspend = {
      name = "Power: Suspend";
      comment = "Suspend the system";
      exec = "systemctl suspend";
      icon = "system-suspend";
      type = "Application";
      categories = [ "System" ];
      noDisplay = false;
    };

    power-logout = {
      name = "Power: Logout";
      comment = "Exit niri session";
      exec = "niri msg action quit";
      icon = "system-log-out";
      type = "Application";
      categories = [ "System" ];
      noDisplay = false;
    };

    power-lock = {
      name = "Power: Lock Screen";
      comment = "Lock the screen";
      exec = "loginctl lock-session";
      icon = "system-lock-screen";
      type = "Application";
      categories = [ "System" ];
      noDisplay = false;
    };
  };
}
