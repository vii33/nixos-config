{ ... }:

{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../../modules/system/server-tools.nix
  ];

  _module.args.serverFlakeHost = "home-server";
  system.stateVersion = "25.05";
}
