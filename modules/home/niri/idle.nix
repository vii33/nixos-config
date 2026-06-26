{ pkgs, ... }:

let
  displayOffOnBatterySeconds = 10 * 60;
  suspendOnBatterySeconds = 20 * 60;
  displayOffOnAcSeconds = 20 * 60;

  niriIdle = pkgs.writeShellScript "niri-idle" ''
    set -eu

    on_ac=false
    for supply in /sys/class/power_supply/*; do
      [ -r "$supply/type" ] || continue
      [ "$(cat "$supply/type")" = "Mains" ] || continue
      [ -r "$supply/online" ] || continue
      if [ "$(cat "$supply/online")" = "1" ]; then
        on_ac=true
        break
      fi
    done

    case "$1" in
      battery)
        [ "$on_ac" = false ] || exit 0
        ;;
      ac)
        [ "$on_ac" = true ] || exit 0
        ;;
      *)
        exit 2
        ;;
    esac

    case "$2" in
      monitors-off)
        exec ${pkgs.niri}/bin/niri msg action power-off-monitors
        ;;
      suspend)
        exec ${pkgs.systemd}/bin/systemctl suspend
        ;;
      *)
        exit 2
        ;;
    esac
  '';
in
{
  services.swayidle = {
    enable = true;
    events.before-sleep = "${pkgs.systemd}/bin/loginctl lock-session";
    timeouts = [
      {
        timeout = displayOffOnBatterySeconds;
        command = "${niriIdle} battery monitors-off";
      }
      {
        timeout = suspendOnBatterySeconds;
        command = "${niriIdle} battery suspend";
      }
      {
        timeout = displayOffOnAcSeconds;
        command = "${niriIdle} ac monitors-off";
      }
    ];
  };
}
