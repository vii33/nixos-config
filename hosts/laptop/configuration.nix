# /etc/nixos/system/configuration.nix
{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = false;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    configurationLimit = 10;
    copyKernels = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.timeout = 5;

  # HIBERNATION
  boot.resumeDevice = "/dev/disk/by-uuid/13694fb1-8976-433c-bd9a-6d7822d109f6";

  # NETWORK
  networking.hostName = "laptop2"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # NetworkManager Configuration
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  # WIREGUARD HAS TO BE DONE BY SCRIPT OR UI:
  # nmcli connection import type wireguard file my-wg-config.conf
  # Set the imported profile's interface name to wg0 so SSH is reachable over VPN.

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  hardware.graphics.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Keep Caps Lock free as a terminal prefix key.
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main.capslock = "f15";
    };
  };

  # Console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Bluetooth
  services.blueman.enable = true; # Blueman provides a GUI for Bluetooth management, although KDE's own tools should work too.
  hardware.bluetooth.enable = true;

  # Thunderbolt
  services.hardware.bolt.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Disable automatic login to allow session selection (niri or KDE)
  # To enable auto-login, set autoLogin.enable = true and specify autoLogin.user
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "vii";

  services.libinput = {
    enable = true;
  };

  # NETWORK SHARES #########################################################
  #fileSystems."/mnt/nas-nfs" = {
  #    device = "192.168.1.200:/volume1/spiele";    # <NAS_IP>:/volumeX/<ShareName> :contentReference[oaicite:12]{index=12}
  #    fsType = "nfs";
  #    options = [
  #        "rw"                  # read/write :contentReference[oaicite:13]{index=13}
  #        "noauto"              # do not block boot if unreachable :contentReference[oaicite:14]{index=14}
  #        "x-systemd.automount" # mount on first access :contentReference[oaicite:15]{index=15}
  #        "proto=tcp"           # use TCP for reliability (optional) :contentReference[oaicite:16]{index=16}
  #        "timeo=14"            # NFS timeout (optional) :contentReference[oaicite:17]{index=17}
  #    ];
  #};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # SERVICES
  #services.onedrive.enable = true;

  # Enable SSH for phone/remote access over WireGuard.
  services.openssh = {
    enable = true;
    openFirewall = false;
  };

  # Open SSH only on the WireGuard interface.
  networking.firewall.interfaces.wg0.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
