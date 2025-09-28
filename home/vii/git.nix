# profiles/home/git.nix
{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    userName = "vii33";
    userEmail = "https://x.com/vii33_official";

    extraConfig = {
      pull = {
        rebase = true;
      };
    };
  };
}