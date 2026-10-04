# modules/home/niri/noctalia.nix
# Noctalia Shell configuration for the Niri desktop
{
  config,
  niriWallpaper ? null,
  ...
}:

let
  wallpaper =
    if niriWallpaper != null then
      toString niriWallpaper
    else
      "${config.home.homeDirectory}/Pictures/Wallpapers/alghozy-7TfUCBVR0nI-unsplash.jpg";
  palettesDir = ../../../dotfiles/noctalia/colorschemes;
in

{
  programs.noctalia = {
    enable = true;
    settings = {
      shell = {
        animation.enabled = false;
        telemetry_enabled = false;
        polkit_agent = false; # Niri already starts the GNOME authentication agent.
        clipboard_auto_paste = "off";
        launcher = {
          auto_paste = "off";
          providers.session.global = true;
        };
      };
      bar.main = {
        position = "top";
        background_opacity = 0.35;
        margin_ends = 4;
        margin_edge = 4;
        padding = 4;
        font_scale = 1.18;
        widget_spacing = 7;
        capsule = true;
        capsule_opacity = 0.54;
        start = [
          "launcher"
          "taskbar"
        ];
        center = [ "workspaces" ];
        end = [
          "tray"
          "network"
          "cpu"
          "memory"
          "battery"
          "brightness"
          "volume"
          "clock"
          "control-center"
        ];
      };
      widget.clock.format = "{:%H:%M -- %d %B}";
      theme = {
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "m3-content";
      };
      wallpaper = {
        enabled = true;
        default.path = wallpaper;
        directory = "${config.home.homeDirectory}/repos/nixos-config/assets/wallpapers";
      };
      # swayidle owns the battery/AC screen-off and suspend policy.
      idle.behavior = {
        lock.enabled = false;
        screen-off.enabled = false;
      };
      dock.enabled = false;
      weather.enabled = false;
      location.address = "Berlin, Germany";
      audio.enable_overdrive = false;
      plugins.auto_update = "none";
    };
    customPalettes = {
      "Ayu Blue" = palettesDir + "/Ayu Blue/Ayu Blue.json";
      "Ayu Red" = palettesDir + "/Ayu Red/Ayu Red.json";
      "Tokyo Night Moon" = palettesDir + "/Tokyo Night Moon/Tokyo Night Moon.json";
    };
  };
}
