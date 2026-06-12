# test
{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  programs.fish.shellAbbrs.ka = "keepawake";
}
