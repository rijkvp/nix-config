rec {
  themeName = "Catppuccin Mocha";
  wallpapers = "catppuccin";
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
  primary = palette.lavender;
  terminalColors = {
    normal = {
      black = black;
      red = red;
      green = green;
      yellow = yellow;
      blue = blue;
      magenta = magenta;
      cyan = cyan;
      white = white;
    };
    bright = {
      black = palette.surface2;
      red = red;
      green = green;
      yellow = yellow;
      blue = blue;
      magenta = magenta;
      cyan = cyan;
      white = palette.subtext0;
    };
  };
}