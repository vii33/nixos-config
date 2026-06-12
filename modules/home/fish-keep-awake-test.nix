# modules/home/fish-keep-awake.nix
{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  programs.fish = {
    shellAbbrs = {
      ka = "keepawake";
    };

    functions.keepawake = {
      description = "Keep the laptop awake for N minutes";
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

        echo "Keeping system awake for $minutes minutes. Press Ctrl+C to cancel."
        command systemd-inhibit --what=sleep:idle --why="keepawake $minutes minutes" -- sleep "$minutes"m
      '';
    };
  };
}
