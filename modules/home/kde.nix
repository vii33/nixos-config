{ config, pkgs, ... }:

{
  # Disable KDE Wallet to prevent credential/password prompts
  # Wi-Fi credentials are handled by NetworkManager instead
  xdg.configFile."kwalletrc".text = ''
    [Wallet]
    Enabled=false
  '';

  # Also disable the KDE Wallet daemon
  services.kdeconnect.enable = false;
}
