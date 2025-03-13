{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";

    launcher.url = "git+ssh://git@github.com/rijkvp/launcher?ref=main";
    launcher.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    {
      nixosModules = import ./modules;

      nixosConfigurations =
        builtins.mapAttrs
          (
            hostname: options:
            let
              inherit (options) system;
              nixpkgsConfig = {
                allowUnfree = true;
                allowUnfreePredicate = _: true;
              };
              pkgs = import nixpkgs {
                inherit system;
                config = nixpkgsConfig;
              };
              unstable-pkgs = import nixpkgs-unstable {
                inherit system;
                config = nixpkgsConfig;
              };
            in
            nixpkgs.lib.nixosSystem {
              specialArgs = {
                # passes arguments to nixos config
                inherit inputs pkgs unstable-pkgs;
              };
              modules = [
                ./hosts/${hostname}
                home-manager.nixosModules.home-manager
                {
                  # pkgs is passed automatically
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.rijk = import ./home/${hostname}.nix;
                  home-manager.backupFileExtension = "backup";
                  home-manager.extraSpecialArgs = {
                    # passes arguments to home-manager config
                    inherit inputs unstable-pkgs;
                    settings = options.settings;
                  };
                }
              ];
            }
          )
          {
            zeus = {
              system = "x86_64-linux";
              settings = {
                font = "Fira Code Nerd Font";
                screenMargin = 20;
                scratchpadMargin = 256;
              };
            };
            apollo = {
              system = "x86_64-linux";
              settings = {
                font = "Fira Code Nerd Font";
                screenMargin = 12;
                scratchpadMargin = 64;
              };
            };
          };
    };
}
