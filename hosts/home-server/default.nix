{ ... }:

{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../../modules/system/server-tools.nix
    ../../modules/system/server-desktop.nix
  ];

  _module.args.serverFlakeHost = "home-server";
  system.stateVersion = "25.05";
}
