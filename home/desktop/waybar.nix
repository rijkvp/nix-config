{ lib, config, pkgs, theme, inputs, ... }: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        spacing = 8;
        modules-left = [ "hyprland/workspaces" "mpd" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "wireplumber" "battery" "backlight" "network" "clock" "tray" ];
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          active-only = false;
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
        font-family: ${theme.font};
      }
      window#waybar {
         font-size: 13px;
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
      #workspaces, #window, #mpd, #clock, #backlight, #battery, #cpu, #memory, #network, #wireplumber, #tray, #mode {
        border-radius: ${theme.rounding}px;
        color: ${theme.foreground};
        margin: 4px 0px;
        padding: 0px 6px;
      }

      #clock, #wireplumber, #workspaces {
        color: ${theme.background};
        background: ${theme.primary};
        box-shadow: 0px 0px 2px 3px ${theme.backgroundAlt};
        font-weight: 600;
        font-size: 14px;
      }

      #workspaces button {
        padding: 0 4px;
        font-size: 14px;
        font-weight: 600;
        color: ${theme.background};
      }
      #workspaces button.active {
        border-radius: ${theme.rounding}px;
        background-color: ${theme.background};
        color: ${theme.foreground};
      }
      #workspaces button.urgent {
        background-color: ${theme.yellow};
      }
    '';
  };
}
