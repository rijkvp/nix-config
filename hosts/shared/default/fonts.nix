{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    liberation_ttf
    fira
    fira-sans
    fira-code
    vistafonts
    open-sans
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    roboto
    roboto-mono
    ubuntu-sans
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Fira Sans" ];
    monospace = [ "Fira Code Nerd Font" ];
  };
}
