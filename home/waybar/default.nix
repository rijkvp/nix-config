{ inputs, outputs, lib, config, pkgs, theme, ... }: {
  nixpkgs = {
    overlays = [
      (self: super: {
        waybar = super.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
      })
    ];
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        spacing = 8;
        modules-left = [ "wlr/workspaces" "hyprland/window" ];
        modules-center = [ ];
        modules-right = [ "mpd" "custom/movebeam" "pulseaudio" "cpu" "memory" "battery" "backlight" "network" "clock" "tray" ];
        "wlr/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          active-only = false;
          format-icons = {
            "1" = "I";
            "2" = "II";
            "3" = "III";
            "4" = "IV";
            "5" = "V";
            "6" = "VI";
            "7" = "VII";
            "8" = "VIII";
          };
          sort-by-number = true;
        };
        "custom/movebeam" = {
          exec = "movebeam get break";
          format = "󱎫  {}";
          interval = 1;
        };
        "mpd" = {
          format = "{stateIcon} <span color=\"${theme.foreground}\">{artist} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S} {songPosition}|{queueLength})</span>";
          format-disconnected = "  Disconnected";
          format-stopped = "";
          unknown-tag = "N/A";
          interval = 1;
          state-icons = {
            paused = " ";
            playing = " ";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          on-click = "mpc toggle";
        };
        "backlight" = {
          format = "{icon} <span color=\"${theme.foreground}\">{percent}%</span>";
          format-icons = [ " " " " ];
        };
        "pulseaudio" = {
          format = "{icon} <span color=\"${theme.foreground}\">{volume}%</span>";
          format-muted = "󰝟 ";
          format-icons = [ " " " " " " ];
        };
        "wireplumber" = {
          format = "󰕾  {volume}%";
          format-muted = "婢 ";
          # icon does not work (yet): https://github.com/Alexays/Waybar/issues/1852
          # format-icons = [" " " " " "];
        };
        "cpu" = {
          interval = 1;
          format = "󰓅  <span color=\"${theme.foreground}\">{usage}% {avg_frequency:0.1f}GHz</span>";
        };
        "memory" = {
          interval = 1;
          format = "󰍛  <span color=\"${theme.foreground}\">{percentage}%</span>";
          tooltip-format = "{used:0.1f}/{total:0.1f}GiB RAM - {swapUsed:0.1f}/{swapTotal:0.1f}GiB swap";
        };
        "battery" = {
          format = "{icon}<span color=\"${theme.foreground}\">{capacity}%</span>";
          format-icons = [ "  " "  " "  " "  " "  " ];
          format-charging = "󰂄  <span color=\"${theme.foreground}\">{capacity}%</span>";
        };
        "network" = {
          format-wifi = "  <span color=\"${theme.foreground}\">{essid} {signalStrength}%</span>";
          format-ethernet = "󰈀  <span color=\"${theme.foreground}\">{ipaddr}/{cidr}</span>";
          format-disconnected = "  Disconnected";
          format = "  Disabled";
        };
        "clock" = {
          interval = 1;
          format = "󰃰  <span color=\"${theme.foreground}\">{:%m-%d %H:%M}</span>";
          format-alt = "󰃰  <span color=\"${theme.foreground}\">{:%Y-%m-%d %H:%M:%S}</span>";
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
        font-family: Iosevka Nerd Font;
        font-size: 14px;
        color: ${theme.foreground};
      }
      window#waybar {
         background: transparent;
      }
      tooltip {
        background: ${theme.backgroundAlt};
        border-radius: ${theme.rounding}px;
      }
      tooltip label {
        color: ${theme.foreground};
      }
      #workspaces button {
        border-bottom: ${theme.borderWidth}px solid transparent;
        padding: 0 2px;
        margin: 0 6px;
        color: ${theme.green};
      }

      #workspaces button.active {
        border-bottom: 2px solid ${theme.primary};
        border-radius: 0px;
        color: ${theme.primary};
      }
      #workspaces button.urgent {
        background-color: ${theme.yellow};
      }

      #workspaces, #window, #custom-movebeam, #mpd, #clock, #backlight, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #mode {
        background-color: ${theme.backgroundAlt};
        border-radius: ${theme.rounding}px;
        box-shadow: 0px 0px 2px 3px ${theme.backgroundAlt};
        margin: 4px 8px;
        padding: 0px 6px;
      }

      #mpd {
        font-size: 13px;
        font-weight: normal;
        color: ${theme.magenta};
        border-bottom: 1px solid ${theme.magenta};
      }

      #clock {
        color: ${theme.red};
        border-bottom: 1px solid ${theme.red};
      }
      #backlight {
        color: ${theme.yellow};
        border-bottom: 1px solid ${theme.yellow};
      }
      #network {
        color: ${theme.orange};
        border-bottom: 1px solid ${theme.orange};
      }
      #battery {
        color: ${theme.green};
        border-bottom: 1px solid ${theme.green};
      }
      #memory {
        color: ${theme.cyan};
        border-bottom: 1px solid ${theme.cyan};
      }
      #cpu {
        color: ${theme.cyan};
        border-bottom: 1px solid ${theme.cyan};
      }
      #pulseaudio {
        color: ${theme.blue};
        border-bottom: 1px solid ${theme.blue};
      }
      #custom-movebeam {
        color: ${theme.purple};
        border-bottom: 1px solid ${theme.purple};
      }
    '';
  };
}
