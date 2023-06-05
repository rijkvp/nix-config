{
  description = "My NixOS configuration.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";

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

      catppuccinTheme = rec {
        themeName = "Catppuccin Mocha";
        borderWidth = "1";
        border = palette.overlay0;
        borderActive = palette.lavender; 
        rounding = "4";
        # Colors from: https://github.com/catppuccin/catppuccin
        palette = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
        background = palette.base;
        backgroundAlt = palette.mantle;
        foreground = palette.text;
        foregroundAlt = palette.subtext1;
        black = palette.surface1;
        white = palette.subtext1;
        red = palette.red;
        green = palette.green;
        orange = palette.peach;
        yellow = palette.yellow;
        cyan = palette.teal;
        blue = palette.blue;
        purple = palette.mauve;
        magenta = palette.pink;
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
            black = palette.surface2;
            red = theme.red;
            green = theme.green;
            yellow = theme.yellow;
            blue = theme.blue;
            magenta = theme.magenta;
            cyan = theme.cyan;
            white = palette.subtext0;
          };
        };
      };
      tokyoNightTheme = rec {
        themeName = "Tokyo Night";
        borderWidth = "1";
        rounding = "4";
        border = "#9aa5ce";
        borderActive = cyan;
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
        purple = "#bb9af7";
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
      # A theme can be set here
      theme = catppuccinTheme;

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
