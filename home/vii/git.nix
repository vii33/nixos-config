# profiles/home/git.nix
{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "vii33";
        email = "1887246+vii33@users.noreply.github.com";
      };
      pull = {
        rebase = true;
      };
    };
  };
}