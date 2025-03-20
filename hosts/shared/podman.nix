{ pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true; # docker alias
      defaultNetwork.settings.dns_enabled = true;
    };
    containers.enable = true;
  };
  environment.systemPackages = with pkgs; [ distrobox ];
}
