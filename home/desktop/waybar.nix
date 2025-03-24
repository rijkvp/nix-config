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
          format-icons = [
            ""
            ""
          ];
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
          format-charging = "󰂄  {capacity}%";
        };
        "network" = {
          format-wifi = " {essid} {signalStrength}%";
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
    style =
      let
        palette = config.colorScheme.palette;
      in
      ''
        * {
          margin: 0;
          padding: 0;
          border: none;
          font-family: ${settings.font};
          min-height: 0;
          font-size: 14px;
        }
        window#waybar {
           all:unset;
           margin: 8px 0;
        }
        .modules-left {
          margin: 0 ${toString settings.screenMargin}px;
        }
        .modules-right {
          margin: 0 ${toString settings.screenMargin}px;
        }
        tooltip {
          background: #${palette.base01};
          border-radius: 4px;
        }
        tooltip label {
          color: #${palette.base05};
        }
        #mpd, #clock, #backlight, #battery, #cpu, #memory, #network, #wireplumber, #tray, #mode {
          color: #${palette.base05};
          margin: 0px 4px;
          padding: 2px 5px;
        }

        button, button:hover, button.focused {
          box-shadow: none;
        }

        #workspaces button {
          all: unset;
          padding: 0px 5px;
          color: #${palette.base05};
        }
        #workspaces button:hover {
          border: none;
          background: #${palette.base01};
        }
        #workspaces button.focused {
          border: none;
          color: #${palette.base0D};
        }
        #workspaces button.active {
          border: none;
          background: #${palette.base01};
        }
        #workspaces button.urgent {
          border: none;
          background: #${palette.base0B};
        }
      '';
  };
}
