{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.services.movebeam;
  movebeam-pkg = inputs.movebeam.packages.${pkgs.system}.default;
in
{
  options.services.movebeam = {
    enable = lib.mkEnableOption "Enable movebeam service";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ movebeam-pkg ];
    systemd.services.actived = {
      description = "Movebeam Activity Daemon";
      script = "${movebeam-pkg}/bin/actived";
      wantedBy = [ "multi-user.target" ]; # automatically start on boot
    };
  };
}
