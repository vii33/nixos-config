# /etc/nixos/system/configuration.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  loginWallpaper = ../../assets/wallpapers/noctalia-login-wallpaper.jpg;
  greetdNiriConfig = pkgs.writeText "greetd-niri.kdl" ''
    spawn-sh-at-startup "${pkgs.regreet}/bin/regreet; ${pkgs.niri}/bin/niri msg action quit --skip-confirmation"

    hotkey-overlay {
      skip-at-startup
    }

    input {
      keyboard {
        xkb {
          layout "de"
        }
      }
    }
  '';
in

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

  hardware.enableRedistributableFirmware = true;
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
      settings.main.capslock = "f18";
    };
  };

  # Console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Nautilus uses GVFS backends for smb:// and other network locations.
  services.gvfs.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    # Enable only when Steam/Wine-style 32-bit ALSA apps are needed. This pulls
    # an i686 PipeWire/FFADO stack that can force local OpenBLAS builds, which
    # take hours on this laptop.
    alsa.support32Bit = false;
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

  # Fingerprint reader support. Enroll fingers manually with `fprintd-enroll`.
  services.fprintd.enable = true;

  # ReGreet provides a modern greetd login screen for both Niri and Plasma.
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.niri}/bin/niri --config ${greetdNiriConfig}";
      user = "greeter";
    };
  };
  programs.regreet = {
    enable = true;
    settings = {
      GTK = {
        application_prefer_dark_theme = lib.mkForce true;
        font_name = lib.mkForce "JetBrainsMono Nerd Font 14";
        theme_name = lib.mkForce "Adwaita-dark";
      };
      background = {
        path = toString loginWallpaper;
        fit = "Cover";
      };
      appearance.greeting_msg = "Welcome back, vii";
      widget.clock = {
        format = "%a %d %b  %H:%M";
        resolution = "1s";
      };
    };
    extraCss = ''
      window {
        background: #10121a;
      }

      box#body {
        background: rgba(24, 26, 38, 0.86);
        border: 1px solid rgba(169, 177, 214, 0.28);
        border-radius: 18px;
        box-shadow: 0 24px 80px rgba(0, 0, 0, 0.55);
        padding: 32px;
      }
    '';
  };

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    dolphin
    dolphin-plugins
  ];

  # Disable automatic login to allow session selection (niri or KDE)
  # To enable auto-login, set autoLogin.enable = true and specify autoLogin.user
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "vii";

  services.libinput = {
    enable = true;
  };

  # NETWORK SHARES #########################################################
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/4242702242701D3B";
    fsType = "ntfs3";
    options = [
      "nofail"
      "x-systemd.automount"
      "uid=1000"
      "gid=100"
      "umask=022"
    ];
  };

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

  services.power-profiles-daemon.enable = true;

  # Preserve battery health by limiting Lenovo firmware charging to 85%.
  systemd.services.battery-charge-limit = {
    description = "Set battery charge limit";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "set-battery-charge-limit" ''
        set -eu

        threshold=85
        for path in \
          /sys/class/power_supply/BAT0/charge_control_end_threshold \
          /sys/class/power_supply/BAT0/charge_stop_threshold; do
          if [ -w "$path" ]; then
            printf '%s\n' "$threshold" > "$path"
            exit 0
          fi
        done

        printf '%s\n' "No writable BAT0 charge threshold found" >&2
        exit 1
      '';
    };
  };

  # Enable SSH for phone/remote access over WireGuard.
  services.openssh = {
    enable = true;
    openFirewall = false;
  };

  # Open SSH only on the WireGuard interface.
  networking.firewall.interfaces.wg0.allowedTCPPorts = [ 22 ];
  networking.firewall.interfaces.wlp0s20f3.allowedTCPPorts = [ 4096 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
