{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Enable KDE Wallet for credential storage (VS Code, GitHub Copilot, etc.)
  # NOTE: If auto-login is enabled, PAM cannot auto-unlock the wallet.
  # With auto-login disabled (default), the wallet will auto-unlock on login.
  # If you enable auto-login and want wallet auto-unlock, create wallet with EMPTY password:
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

  # Natural scrolling and reduced scroll speed for touchpad (libinput) in KDE Plasma
  home.activation.configureKdeTouchpad = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    kcminputrc="$HOME/.config/kcminputrc"
    kwriteconfig="${pkgs.kdePackages.kconfig}/bin/kwriteconfig6"

    if [ -L "$kcminputrc" ]; then
      $VERBOSE_ECHO "Removing read-only $kcminputrc symlink"
      rm "$kcminputrc"
    fi

    mkdir -p "$HOME/.config"
    "$kwriteconfig" --file "$kcminputrc" --group Libinput --group Defaults \
      --group Touchpad --key NaturalScroll true
    "$kwriteconfig" --file "$kcminputrc" --group Libinput --group Defaults \
      --group Touchpad --key ScrollFactor 0.5

    while IFS= read -r groupLine; do
      inner="''${groupLine#\[}"
      inner="''${inner%\]}"
      readarray -t groups < <(printf '%s\n' "$inner" | sed 's/]\[/\n/g')

      groupArgs=()
      for group in "''${groups[@]}"; do
        groupArgs+=(--group "$group")
      done

      "$kwriteconfig" --file "$kcminputrc" "''${groupArgs[@]}" --key NaturalScroll true
      "$kwriteconfig" --file "$kcminputrc" "''${groupArgs[@]}" --key ScrollFactor 0.5
    done < <(grep -E '^\[Libinput\].*\[Touchpad\]$' "$kcminputrc" || true)
  '';

  home.activation.configureKdeShortcuts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    shortcutsrc="$HOME/.config/kglobalshortcutsrc"
    kwriteconfig="${pkgs.kdePackages.kconfig}/bin/kwriteconfig6"

    mkdir -p "$HOME/.config"

    # keyd maps left Meta + left Alt to Ctrl+Shift+Meta+F11 for Handy.
    "$kwriteconfig" --file "$shortcutsrc" --group kmix --key mic_mute \
      'none,Microphone Mute\tMeta+Volume Mute,Mute Microphone'
    "$kwriteconfig" --file "$shortcutsrc" --group services \
      --group handy-toggle-transcription.desktop --key _launch \
      'none,none,Toggle Handy transcription'
  '';

  home.packages = with pkgs; [
    libinput # For debugging: libinput list-devices, libinput debug-events
    libsecret # Required for VS Code/apps to store secrets in KDE Wallet via Secret Service API
    kdePackages.kwalletmanager # GUI to manage KDE Wallet (create wallet with empty password for auto-unlock)
  ];
}
