{ pkgs, config, ... }:
let
  filtersFile = "${config.home.homeDirectory}/.local/share/rclone-backup-filters";
in
{
  home.packages = with pkgs; [
    rclone
  ];

  home.file."${filtersFile}".text = ''
    # directories to alwasys exclude
    - **/.stfolder*/**
    - **/.git/**
    - **/.cache/**
    - **/.thumbnails/**
    - **/.direnv/**
    - **/.devenv/**
    # cache dirs in repos
    - /repos/**/.gradle/**
    - /repos/**/.idea/**
    - /repos/**/.sqlx/**
    - /repos/**/.svelte-kit/**
    - /repos/**/.vscode/**
    - /repos/**/build/**
    - /repos/**/node_modules/**
    - /repos/**/obj/**
    - /repos/**/target/**
    # directories to include
    + /archive/**
    + /music/**
    + /docs/**
    + /pics/**
    + /repos/**
    # exclude everything else
    - **
  '';

  systemd.user.services."rclone-backup" = {
    Unit = {
      Description = "Backup home directory to Proton Drive using rclone";
      After = "network-online.target"; # ensure network is up before running
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.rclone}/bin/rclone sync -vv --ignore-case --filter-from ${filtersFile} --exclude-if-present=\"CACHEDIR.TAG\" --protondrive-replace-existing-draft=true --protondrive-enable-caching \"${config.home.homeDirectory}/\" \"protondrive:backup/\"";
    };
  };

  systemd.user.timers."rclone-backup" = {
    Unit = {
      Description = "Runs rclone-backup service every day";
      Requires = [ "rclone-backup.service" ];
    };
    Timer = {
      OnBootSec = "1h";
      Persistent = true; # persist across reboots
    };
    Install = {
      WantedBy = [ "timers.target" ]; # start automatically at boot
    };
  };
}
