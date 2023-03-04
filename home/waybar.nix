{ inputs, outputs, lib, config, pkgs, ... }: {
   nixpkgs = {
     overlays = [
     (self: super: {
	 waybar = super.waybar.overrideAttrs (oldAttrs: {
	  mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
	});
      }) ]; };

      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            spacing = 8;
            modules-left = [ "wlr/workspaces" "hyprland/window" ];
            modules-center = [ ];
            modules-right = [ "mpd" "pulseaudio" "cpu" "memory" "battery" "backlight" "network" "clock" "tray" ];
            "wlr/workspaces" = {
              format = "{icon}";
              on-click = "activate";
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
            "mpd" = {
              format = "{stateIcon} {artist} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S} {songPosition}|{queueLength})";
              format-disconnected = "  Disconnected";
              format-stopped = "";
              unknown-tag = "N/A";
              interval = 1;
              state-icons = {
                  paused = " "; playing = " "; };
              tooltip-format = "MPD (connected)";
              tooltip-format-disconnected = "MPD (disconnected)";
              on-click = "mpc toggle";
            };
            "backlight" = {
              format = "{icon} {percent}%";
              format-icons = [" " " "];
            };
            "pulseaudio" = {
                format = "{icon} {volume}%";
                format-muted = "婢 ";
                format-icons = [" " " " " "];
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
              format-icons = ["  " "  " "  " "  " "  "];
              format-charging = "{capacity}% 󰂄 ";
            };
            "network" = {
              format-wifi = "  {essid} {signalStrength}%";
              format-ethernet = "󰈀  {ipaddr}/{cidr} ";
              format-disconnected = "  Disconnected";
            };
            "clock" = {
              interval = 1;
              format = "{:%m-%d %H:%M}";
              format-alt = "{:%Y-%m-%d %H:%M:%S}";
            };
            "tray" = {
              spacing = 10;
            };
          };
        };
        style = ''
          * {
            border: none;
            border-radius: 0;
            margin: 0;
            padding: 0;
            font-family: Iosevka Nerd Font;
            font-size: 14px;
            font-weight: bold;
         }

          window#waybar {
            background-color: rgba(0,0,0,0.0);
            color: white;
          }

          #workspaces button {
              padding: 0 5px;
              background: transparent;
              color: white;
              border-top: 3px solid transparent;
          }
          #workspaces button.active {
              color: #549ac9;
              border-top: 3px solid #549ac9;
          }
          #workspaces button.urgent {
              color: #c9545d;
              border-top: 3px solid #c9545d;
          }

          #workspaces, #window, #mpd, #clock, #backlight, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #mode {
              padding: 0 6px;
              margin: 0 6px;
              background-color: rgba(0,0,0,0.5);
	      border-radius: 5px;
          }
          #mpd {
            font-size: 13px;
            font-weight: normal;
          }
      '';
    };
}
