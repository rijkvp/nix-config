{ settings, ... }:
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
}
