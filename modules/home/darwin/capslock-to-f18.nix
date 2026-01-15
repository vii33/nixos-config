# ./modules/home/darwin/capslock-to-f18.nix
# Remaps Caps Lock to F18 using macOS hidutil
# F18 can then be used as a leader/hyper key in other applications
{ config, pkgs, ... }:

{
  # Remap Caps Lock to F18 using hidutil (macOS built-in)
  # This runs at login via launchd
  home.file."Library/LaunchAgents/com.local.KeyRemapping.plist".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>com.local.KeyRemapping</string>
      <key>ProgramArguments</key>
      <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006D}]}</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
    </dict>
    </plist>
  '';
}
