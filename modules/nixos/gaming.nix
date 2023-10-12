{ lib, config, ... }:
with lib;
{
  options.modules.gaming = {
    enable = mkEnableOption "Gaming";
  };

  config = mkIf config.modules.gaming.enable {
    programs.steam = {
      enable = true;
    };
  };
}
