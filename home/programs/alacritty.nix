{ config, settings, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window = {
        decorations = "full";
        dynamic_title = true;
        class = {
          instance = "Alacritty";
          general = "Alacritty";
        };
        opacity = 0.8;
        padding = {
          x = 12;
          y = 6;
        };
      };
      font = {
        normal = {
          family = "${settings.font}";
          style = "regular";
        };
        bold = {
          family = "${settings.font}";
          style = "bold";
        };
        size = 12.0;
      };
      mouse = {
        hide_when_typing = true;
      };
      colors =
        let
          palette = config.colorScheme.palette;
        in
        {
          primary = {
            background = "#${palette.base00}";
            foreground = "#${palette.base05}";
            dim_foreground = "#${palette.base03}";
            bright_foreground = "#${palette.base05}";
          };
          normal = {
            black = "#${palette.base00}";
            red = "#${palette.base08}";
            green = "#${palette.base0B}";
            yellow = "#${palette.base0A}";
            blue = "#${palette.base0D}";
            magenta = "#${palette.base0E}";
            cyan = "#${palette.base0C}";
            white = "#${palette.base05}";
          };
          bright = {
            black = "#${palette.base03}";
            red = "#${palette.base08}";
            green = "#${palette.base0B}";
            yellow = "#${palette.base0A}";
            blue = "#${palette.base0D}";
            magenta = "#${palette.base0E}";
            cyan = "#${palette.base0C}";
            white = "#${palette.base05}";
          };
        };
    };
  };
}
