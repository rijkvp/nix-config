{
  description = "My NixOS configuration.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/v0.25.0";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in
    rec {
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      overlays = import ./overlays;
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      # NixOS configs: 'nixos-rebuild --flake .#hostname'
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/desktop
          ];
        };
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/laptop
          ];
        };
      };

      theme = rec {
        themeName = "Tokyo Night";
        borderWidth = "1";
        rounding = "7";
        # Colors from: https://github.com/enkia/tokyo-night-vscode-theme#tokyo-night-and-tokyo-night-storm
        background = "#1a1b26";
        backgroundAlt = "#24283b";
        foreground = "#a9b1d6";
        foregroundAlt = "#565f89";
        black = "#32344a";
        white = "#787c99";
        red = "#f7768e";
        green = "#9ece6a";
        orange = "#ff9e64";
        yellow = "#e0af68";
        cyan = "#449dab";
        blue = "#7aa2f7";
        magenta = "#bb9af7";
        borderColor = "#9aa5ce";
        primary = blue;
        terminalColors = {
          normal = {
            black = theme.black;
            red = theme.red;
            green = theme.green;
            yellow = theme.yellow;
            blue = theme.blue;
            magenta = theme.magenta;
            cyan = theme.cyan;
            white = theme.white;
          };
          bright = {
            black = "#444b6a";
            red = "#ff7a93";
            green = "#b9f27c";
            yellow = "#ff9e64";
            blue = "#7da6ff";
            magenta = "#bb9af7";
            cyan = "#0db9d7";
            white = "#acb0d0";
          };
        };
      };

      # home-manager configs: 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "rijk@desktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs theme; };
          modules = [
            ./home/desktop.nix
          ];
        };
        "rijk@laptop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs theme; };
          modules = [
            ./home/laptop.nix
          ];
        };
      };
    };
}
