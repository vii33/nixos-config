{ ... }:

let
  hardwareConfig = ./hardware-configuration.nix;
in
{
  imports = [
    ./configuration.nix
    ../../modules/system/server-tools.nix
    (
      if builtins.pathExists hardwareConfig then
        hardwareConfig
      else
        throw "Generate hosts/agent-host/hardware-configuration.nix on the new VM; see docs/agent-host.md."
    )
  ];

  _module.args.serverFlakeHost = "agent-host";
}
