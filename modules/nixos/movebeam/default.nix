{ config, lib, pkgs, ... }:
with lib;
let
  movebeam = pkgs.callPackage ./movebeam.nix { };
  cfg = config.services.movebeam;
in
{
  options.services.movebeam = {
    enable = mkEnableOption "movebeam service";
  };

  config = mkIf cfg.enable {
    # Root activity daemon
    systemd.services.actived = {
      description = "movebeam activity daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${movebeam}/bin/actived";
    };
    # Userspace daemon
    systemd.user.services.moved = {
      description = "movebeam daemon";
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${movebeam}/bin/moved";
    };
    environment.systemPackages = [ movebeam ];
  };
}

