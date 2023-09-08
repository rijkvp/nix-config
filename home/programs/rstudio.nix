{ pkgs, ... }: {
  home.packages = with pkgs;
    let
      rstudio-custom = rstudioWrapper.override { packages = with rPackages; [ ggplot2 dplyr ]; };
    in
    [
      rstudio-custom
    ];
}
