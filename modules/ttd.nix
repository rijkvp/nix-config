{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.services.ttd;
  ttd = inputs.ttd.packages.${pkgs.system}.default;
in
{
  options.services.ttd = {
    enable = lib.mkEnableOption "Enable ttd services";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.actived = {
      wantedBy = [ "multi-user.target" ]; # starts the at boot
      script = "${ttd}/bin/actived";
      serviceConfig = {
        Type = "simple";
        User = "root";
      };
    };
  };
}
