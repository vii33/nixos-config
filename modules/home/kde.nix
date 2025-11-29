{ config, pkgs, ... }:

{
  # Enable KDE Wallet for credential storage (VS Code, GitHub Copilot, etc.)
  # IMPORTANT: Since auto-login is enabled, PAM cannot auto-unlock the wallet.
  # You must create the wallet with an EMPTY password for it to auto-unlock:
  #   1. Run: kwalletmanager6
  #   2. Delete existing 'kdewallet' if it has a password
  #   3. Create new wallet named 'kdewallet' with empty password
  xdg.configFile."kwalletrc".text = ''
    [Wallet]
    Enabled=true
    First Use=false
    Default Wallet=kdewallet
    
    [org.freedesktop.secrets]
    apiEnabled=true
  '';

  services.kdeconnect.enable = true;

  # Configure mouse pointer speed for high DPI mice (e.g., Logitech Pro)
  # These settings work with libinput on Wayland (KDE Plasma)
  home.packages = with pkgs; [
    libinput  # For debugging: libinput list-devices, libinput debug-events
    libsecret  # Required for VS Code/apps to store secrets in KDE Wallet via Secret Service API
    kdePackages.kwalletmanager  # GUI to manage KDE Wallet (create wallet with empty password for auto-unlock)
  ];

  # Create libinput configuration file to target only external mice (not touchpad)
  xdg.configFile."libinput/local-overrides.quirks".text = ''
    [Logitech G Pro Mouse]
    MatchName=*Logitech G Pro*     # glob pattern, * is wildcard
    MatchIsPointer=true
    MatchIsTouchpad=false
    AttrPointerAcceleration=-1.0   # -1.0 (slow) to 1.0 (fast), 0 is default
    #AttrAccelProfileFlat=1
  '';
}
