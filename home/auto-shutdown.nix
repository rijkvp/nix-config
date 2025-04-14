{ pkgs, ... }:
{
  systemd.user.services."auto-shutdown" = {
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl poweroff";
    };
  };

  systemd.user.timers."auto-shutdown" = {
    Timer = {
      OnCalendar = "*-*-* 21:00:00";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
