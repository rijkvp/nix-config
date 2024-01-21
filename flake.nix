{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/v0.34.0";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      # pkgs = import nixpkgs { inherit system; };
    in
    {
      # A theme can be set here
      theme = import ./themes/tokyonight.nix;

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
                home-manager.extraSpecialArgs = { inherit inputs outputs; theme = outputs.theme; };
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
                home-manager.extraSpecialArgs = { inherit inputs outputs; theme = outputs.theme; };
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
                home-manager.extraSpecialArgs = { inherit inputs outputs; theme = outputs.theme; };
              }
            ];
          };
      };
    };
}
