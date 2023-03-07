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
    systemd.services.movebeam = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${movebeam}/bin/movebeam";
    };
    environment.systemPackages = [ movebeam ];
  };
}

