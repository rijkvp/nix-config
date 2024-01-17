rec {
  themeName = "Tokyo Night";
  id = "tokyonight";
  borderWidth = "2";
  rounding = "4";
  border = backgroundAlt;
  borderActive = primary;
  font = "Iosevka Nerd Font";
  # Colors from: https://github.com/enkia/tokyo-night-vscode-theme#tokyo-night-and-tokyo-night-storm
  background = "#1a1b26";
  backgroundAlt = "#24283b";
  foreground = "#a9b1d6";
  foregroundAlt = "#565f89";
  black = "#414868";
  white = "#cfc9c2";
  red = "#f7768e";
  green = "#9ece6a";
  orange = "#ff9e64";
  yellow = "#e0af68";
  cyan = "#2ac3de";
  blue = "#7dcfff";
  magenta = "#bb9af7";
  purple = "#bb9af7";
  primary = blue;
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
}
