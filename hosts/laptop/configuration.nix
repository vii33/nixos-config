# /etc/nixos/system/configuration.nix
{ config, pkgs, ... }:

{

# Enable experimental features for Nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Bootloader.
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

networking.hostName = "laptop"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# NetworkManager Configuration
networking.networkmanager = {
  enable = true;
  wifi.backend = "iwd";
  plugins = with pkgs; [
    networkmanager-openvpn
  ];
};

# WIREGUARD HAS TO BE DONE BY SCRIPT:  nmcli connection import type wireguard file my-wg-config.conf

# Set your time zone.
time.timeZone = "Europe/Berlin";

# Select internationalisation properties.
i18n.defaultLocale = "en_US.UTF-8";

i18n.extraLocaleSettings = {
LC_ADDRESS = "de_DE.UTF-8";
LC_IDENTIFICATION = "de_DE.UTF-8";
LC_MEASUREMENT = "de_DE.UTF-8";
LC_MONETARY = "de_DE.UTF-8";
LC_NAME = "de_DE.UTF-8";
LC_NUMERIC = "de_DE.UTF-8";
LC_PAPER = "de_DE.UTF-8";
LC_TELEPHONE = "de_DE.UTF-8";
LC_TIME = "de_DE.UTF-8";
};

# Enable the X11 windowing system.
services.xserver.enable = true;

services.xserver.videoDrivers = [ "nvidia" ];

hardware.nvidia = {
  # This is the line you need to add
  open = false;
  # Modesetting is required for Wayland and recommended for X11
  modesetting.enable = true;
  # Power management is crucial for laptops and desktops alike
  powerManagement.enable = true;
  # This installs the nvidia-settings utility
  nvidiaSettings = true;
  # This selects the proprietary package set.
  # It's the default, but good to be explicit.
  package = config.boot.kernelPackages.nvidiaPackages.stable;
};

hardware.graphics.enable = true;

# Configure keymap in X11
services.xserver.xkb = {
    layout = "de";
    variant = "";
};

# Configure console keymap
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


# Define a user account. Don't forget to set a password with ‘passwd’.
users.users.vii = {
    isNormalUser = true;
    description = "vii";
    extraGroups = [ "networkmanager" "wheel" ];
};

# Enable automatic login for the user.
services.displayManager.autoLogin.enable = true;
services.displayManager.autoLogin.user = "vii";

# Enable the KDE Plasma Desktop Environment.
services.displayManager.sddm.enable = true;
services.desktopManager.plasma6.enable = true;


# PROGRAMS ###################################################
programs.firefox.enable = true;


# Allow unfree packages
nixpkgs.config.allowUnfree = true;

# Change speed for Logitech
services.xserver.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";  # no mouse acceleration
      sensitivity = "-0.6"; # Values from -1 to 1. Negative values decrease speed.
    };
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

fonts.packages = with pkgs; [
# Fonts go here, search on nixos packages website and check
# that NIX EXPRESSION starts with pkgs/data/fonts

# font-awesome_4
];

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };


# SERVICES
services.onedrive.enable = true;

# Enable the OpenSSH daemon.
services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

}
