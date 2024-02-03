{ config, settings, ... }: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";

        font = "${settings.font}:pixelsize=16";
        font-bold = "${settings.font}:pixelsize=16:weight=bold";
        pad = "12x6";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      colors = {
        alpha = 0.8;
        # TODO: Use theme colors
        # background = builtins.substring 1 6 theme.background;
        # foreground = builtins.substring 1 6 theme.foreground;
        #
        # regular0 = builtins.substring 1 6 theme.terminalColors.normal.black;
        # regular1 = builtins.substring 1 6 theme.terminalColors.normal.red;
        # regular2 = builtins.substring 1 6 theme.terminalColors.normal.green;
        # regular3 = builtins.substring 1 6 theme.terminalColors.normal.yellow;
        # regular4 = builtins.substring 1 6 theme.terminalColors.normal.blue;
        # regular5 = builtins.substring 1 6 theme.terminalColors.normal.magenta;
        # regular6 = builtins.substring 1 6 theme.terminalColors.normal.cyan;
        # regular7 = builtins.substring 1 6 theme.terminalColors.normal.white;
        #
        # bright0 = builtins.substring 1 6 theme.terminalColors.bright.black;
        # bright1 = builtins.substring 1 6 theme.terminalColors.bright.red;
        # bright2 = builtins.substring 1 6 theme.terminalColors.bright.green;
        # bright3 = builtins.substring 1 6 theme.terminalColors.bright.yellow;
        # bright4 = builtins.substring 1 6 theme.terminalColors.bright.blue;
        # bright5 = builtins.substring 1 6 theme.terminalColors.bright.magenta;
        # bright6 = builtins.substring 1 6 theme.terminalColors.bright.cyan;
        # bright7 = builtins.substring 1 6 theme.terminalColors.bright.white;
      };
    };
  };
}
