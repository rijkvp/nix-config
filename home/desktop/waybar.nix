{ config, settings, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        spacing = 8;
        reload_style_on_change = true;
        modules-left = [
          "hyprland/workspaces"
          "niri/workspaces"
          "mpd"
          "hyprland/window"
          "niri/window"
        ];
        modules-center = [
        ];
        modules-right = [
          "custom/ttd"
          "tray"
          "wireplumber"
          "cpu"
          "memory"
          "network"
          "backlight"
          "battery"
          "clock"
        ];
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          all-outputs = true;
          sort-by-number = true;
        };
        "hyprland/window" = {
          separate-outputs = true;
        };
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
          };
        };
        "mpd" = {
          format = "{stateIcon} {artist} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S} {songPosition}|{queueLength})";
          format-disconnected = "  Disconnected";
          format-stopped = "";
          unknown-tag = "{filename}";
          interval = 1;
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          on-click = "mpc toggle";
        };
        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = [ "󰃚" "󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠" ];
        };
        "wireplumber" = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 ";
          format-icons = [
            " "
            " "
            " "
          ];
        };
        "cpu" = {
          interval = 1;
          format = "󰓅 {usage}% {avg_frequency:0.1f}GHz";
        };
        "memory" = {
          interval = 1;
          format = "󰍛 {percentage}%";
          tooltip-format = "{used:0.1f}/{total:0.1f}GiB RAM - {swapUsed:0.1f}/{swapTotal:0.1f}GiB swap";
        };
        "battery" = {
          format = "{icon} {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          format-charging = "󰂄 {capacity}%";
        };
        "network" = {
          format-wifi = "  {essid} {signalStrength}%";
          format-ethernet = "";
          format-disconnected = "  Disconnected";
          format = "  Disabled";
        };
        "clock" = {
          interval = 1;
          format = " {:%H:%M   %m-%d}";
          format-alt = " {:%H:%M:%S   %Y-%m-%d}";
        };
        "tray" = {
          spacing = 10;
        };
        "custom/ttd" = {
          exec = "~/.local/bin/ttd-status";
          interval = 1;
        };
      };
    };
    # based on: https://github.com/elifouts/Dotfiles/blob/09f2315ca81e6dc991b0e9d2f8c0c20db47d1a7e/.config/waybar/themes/default/style-default.css
    style =
      let
        palette = config.colorScheme.palette;
      in
      ''
        * {
            font-size: 15px;
            min-height: 0;
            font-family: ${settings.font};
        }
        window#waybar {
            all:unset;
        }
        .modules-left {
            padding: 6px;
            margin: 6 0 0 6;
            border-radius: 0px;
            background: alpha(#${palette.base01},.8);
        }
        .modules-right {
            padding: 6px;
            margin: 6 6 0 0;
            border-radius: 0px;
            background: alpha(#${palette.base01},.8);
        }
        tooltip {
            background:#${palette.base01};
            color: #${palette.base05};
        }
        #clock:hover, #custom-pacman:hover, #custom-notification:hover,#bluetooth:hover,#network:hover,#battery:hover, #cpu:hover,#memory:hover,#temperature:hover{
            transition: all .3s ease;
            color: #${palette.base0D};
        }
        #custom-notification {
            padding: 0px 5px;
            transition: all .3s ease;
            color: #${palette.base05};
        }
        #clock{
            padding: 0px 5px;
            color: #${palette.base05};
            transition: all .3s ease;
        }
        #workspaces {
            padding: 0px 5px;
        }
        #workspaces button {
            all:unset;
            padding: 0px 5px;
            color: alpha(#${palette.base05},.6);
            transition: all .2s ease;
        }
        #workspaces button:hover {
            color: #${palette.base0D};
            border: none;
            transition: all 0.5s ease;
        }
        #workspaces button.active, #workspaces button.empty.active
        {
            color: #${palette.base05};
            border: none;
        }
        #workspaces button.empty {
            color: rgba(0,0,0,0);
            border: none;
        }
        #bluetooth{
            padding: 0px 5px;
            transition: all .3s ease;
            color: #${palette.base05};
        }
        #network{
            padding: 0px 5px;
            transition: all .3s ease;
            color: #${palette.base05};
        }
        #battery{
            padding: 0px 5px;
            transition: all .3s ease;
            color: #${palette.base05};
        }
        #battery.charging {
            color: #26A65B;
        }

        #battery.warning:not(.charging) {
            color: #ffbe61;
        }

        #battery.critical:not(.charging) {
            color: #f53c3c;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }
        #group-expand{
            padding: 0px 5px;
            transition: all .3s ease; 
        }
        #cpu,#memory,#temperature{
            padding: 0px 5px;
            transition: all .3s ease; 
            color: #${palette.base05};
        }
        #tray{
            padding: 0px 2px;
            transition: all .3s ease; 
        }
        #tray menu * {
            padding: 0px 2px;
            transition: all .3s ease; 
        }

        #tray menu separator {
            padding: 0px 2px;
            transition: all .3s ease; 
        }
      '';
  };
}
