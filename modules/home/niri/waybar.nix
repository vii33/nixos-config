# modules/home/niri/waybar.nix
# Waybar status bar configuration for Wayland compositors
{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 3;

        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "custom/separator" "cpu" "memory" "temperature" "custom/separator" "battery" "pulseaudio" "custom/power-profile" "tray" "custom/power" ];

        # Separator
        "custom/separator" = {
          format = "|";
          tooltip = false;
        };

        # Workspaces
        "niri/workspaces" = {
          format = "{name}";  # Use "{index}" to show numbers, or "{index}: {name}" for both
          all-outputs = false;
        };

        # Window title
        "niri/window" = {
          format = "{title}";
          max-length = 50;
          rewrite = {
            "(.*) — Mozilla Firefox" = "🌎 $1";
            "(.*) - kitty" = "  $1";
          };
        };

        # Clock
        clock = {
          timezone = "Europe/Berlin";
          format = "{:%H:%M  %d.%m.%Y}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        # CPU
        cpu = {
          interval = 10;
          format = "CPU {usage:2}%";
          tooltip = true;
        };

        # Memory
        memory = {
          interval = 30;
          format = "RAM {percentage:2}%";
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G";
        };

        # Temperature
        temperature = {
          interval = 10;
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = [ "" "" "" ];
        };

        # Battery
        battery = {
          interval = 30;
          states = {
            good = 90;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [ "" "" "" "" "" ];
        };

        # Network
        network = {
          interval = 30;
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ipaddr}/{cidr}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname} via {gwaddr}";
        };

        # Pulseaudio
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " {volume}%";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };

        # System tray
        tray = {
          spacing = 6;
        };

        # Power profile switcher
        "custom/power-profile" = {
          format = "{icon}";
          format-icons = {
            power-saver = "󰌪";
            balanced = "󱐋";
            performance = "󰓅";
          };
          exec = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl get";
          interval = 30;
          on-click = "${pkgs.writeShellScript "toggle-power-profile" ''
            current=$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get)
            
            case "$current" in
              "power-saver")
                ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced
                ;;
              "balanced")
                ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance
                ;;
              "performance")
                ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
                ;;
            esac
          ''}";
          tooltip-format = "Power Profile: {icon}";
        };

        # Power menu
        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "${pkgs.writeShellScript "power-menu" ''
            choice=$(echo -e "🔒 Lock\n🔄 Restart\n⏻ Shutdown\n🛌 Hibernate\n💤 Suspend" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt="Power: ")
            
            case "$choice" in
              "🔒 Lock") ${pkgs.systemd}/bin/loginctl lock-session ;;
              "🔄 Restart") ${pkgs.systemd}/bin/systemctl reboot ;;
              "⏻ Shutdown") ${pkgs.systemd}/bin/systemctl poweroff ;;
              "🛌 Hibernate") ${pkgs.systemd}/bin/systemctl hibernate ;;
              "💤 Suspend") ${pkgs.systemd}/bin/systemctl suspend ;;
            esac
          ''}";
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 11px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(0, 0, 0, 1);
        color: #ffffff;
        transition-property: background-color;
        transition-duration: .5s;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces button {
        padding: 0 6px;
        background-color: transparent;
        color: #888888;
        border-bottom: 3px solid transparent;
      }

      #workspaces button:hover {
        background: rgba(100, 100, 100, 0.2);
        color: #ffffff;
      }

      #workspaces button.active {
        color: #ffffff;
        background-color: #333333;
        border-bottom: 3px solid #ffffff;
      }

      #workspaces button.urgent {
        background-color: #eb4d4b;
      }

      #window,
      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #custom-separator,
      #tray {
        padding: 0 10px;
        margin: 0 2px;
      }

      #custom-separator {
        color: #64727d;
      }

      #window {
        color: #64727d;
      }

      #battery.charging {
        color: #26A65B;
        font-weight: bold;
      }

      #battery.warning:not(.charging) {
        color: #ffbe61;
        font-weight: bold;
      }

      #battery.critical:not(.charging) {
        font-weight: bold;
        color: #f53c3c;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #temperature.critical {
        color: #f53c3c;
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }
    '';
  };
}
