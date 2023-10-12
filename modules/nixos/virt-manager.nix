{ lib, pkgs, config, ... }:
with lib;
{
  options.modules.virt-manager = {
    enable = mkEnableOption "virt-manager";
  };

  config = mkIf config.modules.virt-manager.enable {
    virtualisation.libvirtd.enable = true;
    environment.systemPackages = with pkgs; [ virt-manager ];
  };
}

