# profiles/home/git.nix
{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    userName = "vii33";
    userEmail = "1887246+vii33@users.noreply.github.com";

    extraConfig = {
      pull = {
        rebase = true;
      };
    };
  };
}