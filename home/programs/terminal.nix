{ config, settings, ... }:
{
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

  programs.kitty = {
    enable = true;
    font = {
      name = "${settings.font}";
      size = 12;
    };
    settings =
      let
        palette = config.colorScheme.palette;
      in
      {
        enable_audio_bell = false;
        update_check_interval = 0;
        hide_window_decorations = true;
        background_opacity = 0.8;

        window_padding_width = 8;

        # https://sw.kovidgoyal.net/kitty/performance/

        input_delay = 0;
        repaint_delay = 2;
        sync_to_monitor = false;
        wayland_enable_ime = false;

        # Based on: https://github.com/kdrag0n/base16-kitty/blob/master/templates/default.mustache

        background = "#${palette.base00}";
        foreground = "#${palette.base05}";
        selection_background = "#${palette.base05}";
        selection_foreground = "#${palette.base00}";

        url_color = "#${palette.base04}";
        cursor = "#${palette.base05}";
        cursor_text_color = "#${palette.base00}";
        active_border_color = "#${palette.base03}";
        inactive_border_color = "#${palette.base01}";
        active_tab_background = "#${palette.base00}";
        active_tab_foreground = "#${palette.base05}";
        inactive_tab_background = "#${palette.base01}";
        inactive_tab_foreground = "#${palette.base04}";
        tab_bar_background = "#${palette.base01}";
        wayland_titlebar_color = "#${palette.base00}";
        macos_titlebar_color = "#${palette.base00}";

        color0 = "#${palette.base00}";
        color1 = "#${palette.base08}";
        color2 = "#${palette.base0B}";
        color3 = "#${palette.base0A}";
        color4 = "#${palette.base0D}";
        color5 = "#${palette.base0E}";
        color6 = "#${palette.base0C}";
        color7 = "#${palette.base05}";

        color8 = "#${palette.base03}";
        color9 = "#${palette.base09}";
        color10 = "#${palette.base01}";
        color11 = "#${palette.base02}";
        color12 = "#${palette.base04}";
        color13 = "#${palette.base06}";
        color14 = "#${palette.base0F}";
        color15 = "#${palette.base07}";
      };
    shellIntegration.enableFishIntegration = true;
  };
}
