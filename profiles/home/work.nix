{ config, pkgs, pkgs-unstable, ... }:
#TODO Merge this file back to dev-desktop and use switches to enable/disable packages (see youtube)
{
  imports = [
    ../../modules/home/fish-shell.nix
    #../../modules/home/nixvim/lazyvim.nix
    #../../modules/home/kitty.nix  # TODO maybe through brew is better? same for lazyvim?
  ];

  home.packages = with pkgs; [
    #pkgs-unstable.opencode
    #pkgs-unstable.github-copilot-cli
  ];
  

}
