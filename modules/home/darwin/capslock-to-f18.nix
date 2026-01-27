# ./modules/home/darwin/capslock-to-f18.nix
# Remaps Caps Lock to F18 using macOS hidutil
# F18 can then be used as a leader/hyper key in other applications
{ config, pkgs, ... }:

{
  # Remap Caps Lock to F18 using hidutil (macOS built-in)
  # Using Home Manager's launchd.agents for proper management
  launchd.agents.KeyRemapping = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/hidutil"
        "property"
        "--set"
        ''{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006D}]}''
      ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
}
