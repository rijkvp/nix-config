{ pkgs, ... }: {
  imports = [
    ./starship.nix
    ./tmux.nix
    ./zsh.nix
  ];

  programs.exa = {
    enable = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = [ pkgs.fd ];
  xdg.configFile."fd/ignore".text = ''
    .*
    .git/
    node_modules/
    target/
    dist/
  '';

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
