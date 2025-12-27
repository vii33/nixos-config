{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    python3
    uv

    flameshot     # Screenshot tool
    imagemagick   # Image manipulation tool
  ];
}
