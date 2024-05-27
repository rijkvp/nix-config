{
  programs.zellij = {
    enable = true;
#    enableFishIntegration = true; # auto start in fish
  };

  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
  xdg.configFile."zellij/layouts/compact-top.kdl".source = ./compact-top.kdl;
}
