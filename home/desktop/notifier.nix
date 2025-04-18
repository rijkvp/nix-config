{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libnotify
  ];

  systemd.user.services."notifier" = {
    Unit = {
      Description = "Notifier service";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.libnotify}/bin/notify-send -u critical -a \"Notifier\" \"TIME TO TAKE A BREAK\"";
    };
  };

  systemd.user.timers."notifier" = {
    Unit = {
      Description = "Timer for notifier service";
    };
    Timer = {
      OnBootSec = "30min";
      OnUnitActiveSec = "30min";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
