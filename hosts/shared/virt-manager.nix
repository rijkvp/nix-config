{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
