{ theme, ... }: {
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
          family = "Iosevka Nerd Font";
          style = "regular";
        };
        bold = {
          family = "Iosevka Nerd Font";
          style = "bold";
        };
        size = 12.0;
      };
      mouse = {
        hide_when_typing = true;
      };
      colors = {
        primary = {
          background = theme.background;
          foreground = theme.foreground;
        };
        normal = theme.terminalColors.normal;
        bright = theme.terminalColors.bright;
      };
    };
  };
}
