{ config, ... }:
{
  programs.beets = {
    enable = true;
    settings = {
      directory = "${config.home.homeDirectory}/music";
    };
  };
}
