let
  borgbackupMonitor =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    with lib;
    {
      key = "borgbackupMonitor";
      _file = "borgbackupMonitor";
      # See Nix Wiki: this ensures backups are made if device was powered off at scheduled time
      config.systemd.timers = flip mapAttrs' config.services.borgbackup.jobs (
        name: value: nameValuePair "borgbackup-job-${name}" { timerConfig.Persistent = mkForce true; }
      );
    };
in
{
  imports = [ borgbackupMonitor ];

  # Borg Backup
  services.borgbackup.jobs.home-backup = {
    paths = "/home/rijk";
    exclude = [
      ".cache"
      ".local/share/Steam"
      "*/.cache"
      "*/.git"
      "**/target"
    ];
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /etc/home-backup-passphrase";
    };
    repo = "/mnt/hdint/home-backup";
    compression = "zstd,8";
    startAt = "daily";
    prune.keep = {
      within = "1d";
      daily = 7;
      weekly = 4;
      monthly = -1;
    };
  };
}
