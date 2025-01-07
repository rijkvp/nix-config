{
  settings,
  ...
}:
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
      cursor.style = "Beam";
      mouse = {
        hide_when_typing = true;
      };
      # Based on: https://raw.githubusercontent.com/edeneast/nightfox.nvim/main/extra/nightfox/alacritty.toml
      # converted using: https://github.com/erooke/toml2nix/
      colors = {
        primary = {
          background = "#192330";
          foreground = "#cdcecf";
          dim_foreground = "#aeafb0";
          bright_foreground = "#d6d6d7";
        };
        cursor = {
          text = "#cdcecf";
          cursor = "#aeafb0";
        };
        vi_mode_cursor = {
          text = "#cdcecf";
          cursor = "#63cdcf";
        };
        search = {
          matches = {
            foreground = "#cdcecf";
            background = "#3c5372";
          };
          focused_match = {
            foreground = "#cdcecf";
            background = "#81b29a";
          };
        };
        footer_bar = {
          foreground = "#cdcecf";
          background = "#29394f";
        };
        hints = {
          start = {
            foreground = "#cdcecf";
            background = "#f4a261";
          };
          end = {
            foreground = "#cdcecf";
            background = "#29394f";
          };
        };
        selection = {
          text = "#cdcecf";
          background = "#2b3b51";
        };
        normal = {
          black = "#393b44";
          red = "#c94f6d";
          green = "#81b29a";
          yellow = "#dbc074";
          blue = "#719cd6";
          magenta = "#9d79d6";
          cyan = "#63cdcf";
          white = "#dfdfe0";
        };
        bright = {
          black = "#575860";
          red = "#d16983";
          green = "#8ebaa4";
          yellow = "#e0c989";
          blue = "#86abdc";
          magenta = "#baa1e2";
          cyan = "#7ad5d6";
          white = "#e4e4e5";
        };
        dim = {
          black = "#30323a";
          red = "#ab435d";
          green = "#6e9783";
          yellow = "#baa363";
          blue = "#6085b6";
          magenta = "#8567b6";
          cyan = "#54aeb0";
          white = "#bebebe";
        };
        indexed_colors = [
          {
            index = 16;
            color = "#f4a261";
          }
          {
            index = 17;
            color = "#d67ad2";
          }
        ];
      };

    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Fira Code"; # don't use nerd font here
      size = 12;
    };
    extraConfig = ''
      # from: kitten choose-fonts
      font_family      family="Fira Code"
      bold_font        auto
      italic_font      auto
      bold_italic_font auto

      # from: kitten themes

      ## name: Nightfox
      ## author: EdenEast
      ## license: MIT
      ## upstream: https://github.com/EdenEast/nightfox.nvim/blob/main/extra/nightfox/nightfox_kitty.conf

      background #192330
      foreground #cdcecf
      selection_background #2b3b51
      selection_foreground #cdcecf
      url_color #81b29a

      # Cursor
      # uncomment for reverse background
      # cursor none
      cursor #cdcecf

      # Border
      active_border_color #719cd6
      inactive_border_color #39506d
      bell_border_color #f4a261

      # Tabs
      active_tab_background #719cd6
      active_tab_foreground #131a24
      inactive_tab_background #2b3b51
      inactive_tab_foreground #738091

      # normal
      color0 #393b44
      color1 #c94f6d
      color2 #81b29a
      color3 #dbc074
      color4 #719cd6
      color5 #9d79d6
      color6 #63cdcf
      color7 #dfdfe0

      # bright
      color8 #575860
      color9 #d16983
      color10 #8ebaa4
      color11 #e0c989
      color12 #86abdc
      color13 #baa1e2
      color14 #7ad5d6
      color15 #e4e4e5

      # extended colors
      color16 #f4a261
      color17 #d67ad2

    '';
    settings = {
      enable_audio_bell = false;
      update_check_interval = 0;
      hide_window_decorations = true;

      window_padding_width = 8;

      confirm_os_window_close = 0; # no confirmation on close

      # https://sw.kovidgoyal.net/kitty/performance/

      input_delay = 0;
      repaint_delay = 2;
      sync_to_monitor = false;
      wayland_enable_ime = false;
    };
    shellIntegration.enableFishIntegration = true;
  };
}
