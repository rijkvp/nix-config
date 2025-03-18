{ inputs, pkgs, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  programs.niri.enable = true;
  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  home.packages = [
    pkgs.xwayland-satellite
  ];
}
