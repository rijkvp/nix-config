{
  description = "My NixOS configurations.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/v0.30.0";
    agenix.url = "github:ryantm/agenix";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    rec {
      # devshell for bootstrapping
      devShells."${system}".default = pkgs.mkShell {
        buildInputs = with pkgs; [ just ];
      };

      # Set a theme here
      themes = import ./themes;
      theme = themes.tokyonight;

      nixosModules = import ./modules/nixos;
      nixosConfigurations =
        {
          zeus = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs nixosModules; };
            modules = [
              ./hosts/zeus
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.rijk = import ./home/zeus.nix;
                home-manager.extraSpecialArgs = { inherit inputs theme; };
              }
            ];
          };
          poseidon = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs nixosModules; };
            modules = [
              ./hosts/poseidon
              inputs.impermanence.nixosModules.impermanence
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.rijk = import ./home/poseidon.nix;
                home-manager.extraSpecialArgs = { inherit inputs theme; };
              }
            ];
          };
          apollo = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs nixosModules; };
            modules = [
              ./hosts/apollo
              inputs.impermanence.nixosModules.impermanence
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.rijk = import ./home/apollo.nix;
                home-manager.extraSpecialArgs = { inherit inputs theme; };
              }
            ];
          };
        };
    };
}
