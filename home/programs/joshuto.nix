{ pkgs, inputs, ... }: {
  # Use the package from unstable
  home.packages = with inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}; [
    joshuto
  ];
}
