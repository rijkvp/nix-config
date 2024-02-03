{ lib, config, pkgs, theme, inputs, ... }: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        spacing = 8;
        modules-left = [ "hyprland/workspaces" "hyprland/window" "mpd" ];
        modules-center = [ ];
        modules-right = [ "tray" "wireplumber" "cpu" "memory" "network" "backlight" "battery" "clock" ];
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          all-outputs = true;
          sort-by-number = true;
        };
        "hyprland/window" = {
          separate-outputs = true;
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
          format-icons = [ "" "" ];
        };
        "wireplumber" = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 ";
          format-icons = [ " " " " " " ];
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
          format-icons = [ "" "" "" "" "" ];
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
      };
    };
    style = ''
      * {
        margin: 0;
        padding: 0;
        border: none;
        font-family: ${theme.font};
        min-height: 0;
        font-size: 13px;
      }
      window#waybar {
         color: ${theme.foreground};
         background: ${theme.background};
         opacity: 0.85;
      }
      .modules-left {
        margin: 0 12px;
      }
      .modules-right {
        margin: 0 12px;
      }
      tooltip {
        background: ${theme.backgroundAlt};
        border-radius: ${theme.rounding}px;
      }
      tooltip label {
        color: ${theme.foreground};
      }
      #mpd, #clock, #backlight, #battery, #cpu, #memory, #network, #wireplumber, #tray, #mode {
        color: ${theme.foreground};
        margin: 0px 4px;
        padding: 2px 5px;
      }

      button, button:hover, button.focused {
        box-shadow: none;
      }

      #workspaces button {
        padding: 2px 5px;
        border-radius: 0;
        background: ${theme.background};
        color: ${theme.foreground};
        border-bottom: 2px solid transparent;
      }
      #workspaces button:hover {
        background: ${theme.backgroundAlt};
      }

      #workspaces button.focused {
        background: ${theme.background};
        border-bottom: 2px solid ${theme.primary};
      }

      #workspaces button.active {
        background: ${theme.backgroundAlt};
        border-bottom: 2px solid ${theme.primary};
      }
      #workspaces button.urgent {
        background: ${theme.yellow};
      }
    '';
  };
}
