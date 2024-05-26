{ pkgs, ... }: {
  imports = [
    ./starship.nix
    ./tmux.nix
    ./fish.nix
    ./zellij
  ];

  programs.eza = {
    enable = true;
    enableAliases = true;
    icons = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    tmux.enableShellIntegration = true;
  };

  home.packages = [ pkgs.fd ];
  xdg.configFile."fd/ignore".text = ''
    .*
    .git/
    node_modules/
    target/
    dist/
    R/
  '';

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
