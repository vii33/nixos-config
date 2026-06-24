# modules/home/niri/noctalia.nix
# Noctalia Shell configuration for the Niri desktop
{ ... }:

{
  programs.noctalia-shell = {
    enable = true;

    settings = {
      bar = {
        position = "top";
        widgets = {
          left = [
            { id = "Launcher"; }
            { id = "ActiveWindow"; }
          ];
          center = [
            { id = "Workspace"; }
          ];
          right = [
            { id = "Tray"; }
            { id = "Battery"; }
            { id = "Volume"; }
            { id = "Brightness"; }
            { id = "Clock"; }
            { id = "ControlCenter"; }
          ];
        };
      };

      location = {
        name = "Berlin, Germany";
        use12hourFormat = false;
      };
    };
  };
}
