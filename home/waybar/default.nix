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
            "1" = " ";
            "2" = " ";
            "3" = " ";
            "4" = " ";
            "5" = " ";
            "6" = " ";
          };
          sort-by-number = true;
        };
        "custom/movebeam" = {
          exec = "movebeam bar break";
          interval = 5;
        };
        "mpd" = {
          format = "{stateIcon} {artist} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S} {songPosition}|{queueLength})";
          format-disconnected = "  Disconnected";
          format-stopped = "";
          unknown-tag = "N/A";
          interval = 1;
          state-icons = {
            paused = " ";
            playing = " ";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          on-click = "mpc toggle";
        };
        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = [ " " " " ];
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "婢 ";
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
          format = "󰓅  {usage}% {avg_frequency:0.1f}GHz";
        };
        "memory" = {
          interval = 1;
          format = "  {percentage}%";
          tooltip-format = "{used:0.1f}/{total:0.1f}GiB RAM - {swapUsed:0.1f}/{swapTotal:0.1f}GiB swap";
        };
        "battery" = {
          format = "{capacity}% {icon}";
          format-icons = [ "  " "  " "  " "  " "  " ];
          format-charging = "{capacity}% 󰂄 ";
        };
        "network" = {
          format-wifi = "  {essid} {signalStrength}%";
          format-ethernet = "󰈀  {ifname}: {ipaddr}/{cidr}";
          format-disconnected = "  Disconnected";
          format = "  Disabled";
        };
        "clock" = {
          interval = 1;
          format = "󰃰 {:%m-%d %H:%M}";
          format-alt = "󰃰 {:%Y-%m-%d %H:%M:%S}";
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
        font-weight: bold;
        color: ${theme.foreground};
      }
      tooltip {
        background: ${theme.backgroundAlt};
        border-radius: ${theme.rounding}px;
      }
      tooltip label {
        color: ${theme.foreground};
      }
      window#waybar {
        background-color: transparent;
        color: ${theme.foreground};
      }

      #workspaces button {
        border-bottom: ${theme.borderWidth}px solid transparent;
        border-radius: 0px;
        padding: 0 2px;
        margin: 0 6px;
      }

      #workspaces button.active {
        border-bottom: 2px solid ${theme.primary};
        color: ${theme.primary};
      }

      #custom-themename, #custom-movebeam, #workspaces, #window, #mpd, #clock, #backlight, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #mode {
        background-color: ${theme.background};
        border: ${theme.borderWidth}px solid ${theme.borderColor};
        border-radius: ${theme.rounding}px;
        margin: 0 8px;
        padding: 0 6px;
      }

      #mpd {
        font-size: 13px;
        font-weight: normal;
      }

      #clock {
        color: ${theme.red}
      }
      #network {
        color: ${theme.orange}
      }
      #memory {
        color: ${theme.green}
      }
      #cpu {
        color: ${theme.cyan}
      }
      #pulseaudio {
        color: ${theme.blue}
      }
      #custom-movebeam {
        color: ${theme.magenta}
      }
    '';
  };
}
