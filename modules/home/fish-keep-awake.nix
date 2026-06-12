# modules/home/fish-keep-awake.nix
{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  programs.fish = {
    shellAbbrs = {
      ka = "keepawake";
    };

    functions.keepawake = {
      description = "Keep the laptop awake for N minutes using systemd-inhibit";
      body = ''
        set -l minutes $argv[1]

        if test -z "$minutes"
          set minutes 120
        end

        if not string match -qr '^[1-9][0-9]*$' -- "$minutes"
          echo "Usage: keepawake <minutes>"
          echo "Example: keepawake 120"
          return 2
        end

        if not type -q systemd-inhibit
          echo "systemd-inhibit not found; this helper only works on systemd-based Linux systems" >&2
          return 127
        end

        echo "Keeping system awake for $minutes minutes. Press Ctrl+C to cancel."
        systemd-inhibit \
          --what=sleep:idle:handle-lid-switch \
          --why="keepawake fish helper for $minutes minutes" \
          sleep "$minutes"m
      '';
    };
  };
}
