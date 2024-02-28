{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/v0.36.0";
    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";
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
    in
    {
      packages = import nixpkgs { inherit system; };

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
                  inherit inputs outputs;
                  settings = {
                    font = "Iosevka Nerd Font";
                    screenMargin = 36;
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
                home-manager.extraSpecialArgs = { inherit inputs outputs settings; };
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
                home-manager.extraSpecialArgs = { inherit inputs outputs settings; };
              }
            ];
          };
      };
    };
}
