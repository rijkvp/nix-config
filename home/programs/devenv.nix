{ unstable-pkgs, ... }:
{
  home.packages = [
    unstable-pkgs.devenv
  ];

  programs.direnv.enable = true;
}
