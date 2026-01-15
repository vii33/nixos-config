# ./modules/home/paneru.nix
# Paneru window manager configuration for macOS https://github.com/karinushka/paneru
# MacOS settings: 
  # System Preferences -> Desktop & Dock -> Displays have separate spaces: ON. 
  # System Preferences -> Displays -> Arrange: Align vertically
{ config, pkgs, inputs, ... }:

let
  paneruSettings = {
      options = {
        # Enables focus follows mouse. Enabled by default, set to false to disable.
        # focus_follows_mouse = true;

        # Enables mouse follows focus. Enabled by default, set to false to disable.
        # mouse_follows_focus = true;

        # Array of widths used by the `window_resize` action to cycle between.
        # Defaults to 25%, 33%, 50%, 66% and 75%.
        preset_column_widths = [
          0.33
          0.50
          0.66
        ];

        # How many fingers to use for moving windows left and right.
        # Make sure that it doesn't clash with OS setting for workspace switching.
        # Values lower than 3 will be ignored.
        # Remove the line to disable the gesture feature.
        # Apple touchpads support gestures with more than five fingers (!),
        # but it is probably not that useful to use two hands :)
        swipe_gesture_fingers = 5;

        # Window movement speed in pixels/second.
        # To disable animations, leave this unset or set to a very large value.
        # animation_speed = 9999;
      };

      bindings = {
        # Moves the focus between windows.
        window_focus_west = "cmd - h";
        window_focus_east = "cmd - l";
        window_focus_north = "cmd - k";
        window_focus_south = "cmd - j";

        # Swaps windows in chosen direction.
        window_swap_west = "alt - h";
        window_swap_east = "alt - l";

        # Jump to the left-most or right-most windows.
        window_focus_first = "cmd + shift - h";
        window_focus_last = "cmd + shift - l";

        # Move the current window into the left-most or right-most positions.
        window_swap_first = "alt + shift - h";
        window_swap_last = "alt + shift - l";

        # Centers the current window on screen.
        window_center = "alt - c";

        # Cycles between the window sizes defined in the `preset_column_widths` option.
        window_resize = "alt - r";

        # Toggle full width for the current focused window.
        window_fullwidth = "alt - f";

        # Toggles the window for management. If unmanaged, the window will be "floating".
        window_manage = "ctrl + alt - t";

        # Stacks and unstacks a window into the left column. Each window gets a 1/N of the height.
        window_stack = "alt - 1";
        window_unstack = "alt + shift - 1";

        # Moves currently focused window to another display.
        window_nextdisplay = "alt - n";

        # Quits the window manager.
        quit = "ctrl + alt - q";
      };

      # Window properties, matched by a RegExp title string.
      # Example configurations from the README:
      windows = {
        pip = {
          # Title RegExp pattern is required.
          title = "Picture.*(in)?.*[Pp]icture";
          # Do not manage this window, e.g. it will be floating.
          floating = true;
        };

        neovide = {
          # Matches an editor and always inserts its window at index 1.
          title = ".*";
          bundle_id = "com.neovide.neovide";
          index = 1;
        };

        all = {
          # Matches all windows and adds a few pixels of spacing to their borders.
          title = ".*";
          horizontal_padding = 4;
          vertical_padding = 2;
        };
      };
  };
in
{
  imports = [
    inputs.paneru.homeModules.paneru
  ];

  services.paneru = {
    enable = false;  # Disabled: using cargo-installed paneru instead
    settings = paneruSettings;
  };

  # Create config file for cargo-installed paneru at $HOME/.paneru.toml
  home.file.".paneru.toml" = {
    source = (pkgs.formats.toml {}).generate "paneru.toml" paneruSettings;
  };
}
