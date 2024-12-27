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
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      settings = {
        font = "Fira Code Nerd Font";
        screenMargin = 12;
        scratchpadMargin = 64;
      };
      unstable-pkgs = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages = import nixpkgs { inherit system; };

      nixosModules = import ./modules;

      nixosConfigurations = {
        zeus = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs outputs unstable-pkgs;
          };
          modules = [
            ./hosts/zeus
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.rijk = import ./home/zeus.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs outputs unstable-pkgs;
                settings = settings // {
                  screenMargin = 20;
                  scratchpadMargin = 256;
                };
              };
            }
          ];
        };
        apollo = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./hosts/apollo
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.rijk = import ./home/apollo.nix;
              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  outputs
                  settings
                  unstable-pkgs
                  ;
              };
            }
          ];
        };
      };
    };
}
