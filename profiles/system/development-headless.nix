{ config, pkgs, lib, ... }:

let
  isLinux = builtins.match ".*-linux" (builtins.currentSystem or "") != null;
in
{
  environment.systemPackages = with pkgs; [
    python3
    uv
  ]
  ++ lib.optionals isLinux [
    docker  # Docker is managed via brew on macOS
    docker-compose
  ];

  # NixOS/Linux-only options (these option paths don't exist on nix-darwin)
} // lib.optionalAttrs isLinux {
  environment.localBinInPath = true;
  virtualisation.docker.enable = true;
}
