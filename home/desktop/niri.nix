{ inputs, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  programs.niri.enable = true;
  # programs.niri.package = pkgs.niri;
}
