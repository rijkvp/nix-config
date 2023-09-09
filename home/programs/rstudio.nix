{ pkgs, inputs, ... }: {
  home.packages = with inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
    let
      rstudio-custom = rstudioWrapper.override { packages = with rPackages; [ ggplot2 dplyr rmarkdown reshape2 ]; };
    in
    [
      rstudio-custom
    ];
}
