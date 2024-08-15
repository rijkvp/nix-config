{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";

    movebeam.url = "github:rijkvp/movebeam";
    #    launcher.url = "git+ssh://git@github.com/rijkvp/launcher.git";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      settings = {
        font = "Iosevka Nerd Font";
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
        zeus = nixpkgs.lib.nixosSystem
          {
            inherit system;
            specialArgs = { inherit inputs outputs; };
            modules = [
              ./hosts/zeus
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.rijk = import ./home/zeus.nix;
                home-manager.extraSpecialArgs = {
                  inherit inputs outputs unstable-pkgs;
                  settings = {
                    font = "Iosevka Nerd Font";
                    screenMargin = 20;
                    scratchpadMargin = 256;
                  };
                };
              }
            ];
          };
        poseidon = nixpkgs.lib.nixosSystem
          {
            inherit system;
            specialArgs = { inherit inputs outputs; };
            modules = [
              ./hosts/poseidon
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.rijk = import ./home/poseidon.nix;
                home-manager.extraSpecialArgs = { inherit inputs outputs settings unstable-pkgs; };
              }
            ];
          };
        apollo = nixpkgs.lib.nixosSystem
          {
            inherit system;
            specialArgs = { inherit inputs outputs; };
            modules = [
              ./hosts/apollo
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.rijk = import ./home/apollo.nix;
                home-manager.extraSpecialArgs = { inherit inputs outputs settings unstable-pkgs; };
              }
            ];
          };
      };
    };
}
