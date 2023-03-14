{ lib, config, pkgs, theme, ... }: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland.override { plugins = [ pkgs.rofi-calc ]; };
    theme = "theme.rasi";
  };

  xdg.configFile."rofi/theme.rasi".text = ''
    configuration {
      font: "Iosevka Nerd Font Medium 13";

      drun {
        display-name: "";
      }

      run {
        display-name: "";
      }

      window {
        display-name: "";
      }

      timeout {
        action: "kb-cancel";
      }
    }

    * {
      border: 0;
      margin: 0;
      padding: 0;
      spacing: 0;

      bg: ${theme.background}60;
      bg-alt: ${theme.backgroundAlt}60;
      fg: ${theme.foreground};
      fg-alt: ${theme.foregroundAlt};

      background-color: @bg;
      text-color: @fg;
    }

    window {
      transparency: "real";
    }

    mainbox {
      children: [inputbar, listview];
    }

    inputbar {
      background-color: @bg-alt;
      children: [prompt, entry];
    }

    entry {
      background-color: inherit;
      padding: 12px 3px;
    }

    prompt {
      background-color: inherit;
      padding: 12px;
    }

    listview {
      lines: 20;
    }

    element {
      children: [element-icon, element-text];
      margin: 2px 0;
    }

    element-icon {
      padding: 0 10px;
    }

    element-text {
      padding: 4px 0;
      text-color: @fg-alt;
      highlight: bold underline ${theme.foreground};
    }

    element-text selected {
      text-color: @fg;
    }
  '';

  home.file."${config.home.homeDirectory}/.local/bin/powermenu" = {
    text = ''
      #!/bin/sh
      lock=" Lock"
      suspend="󰒲 Suspend"
      hibernate="󰤄 Hibernate"
      poweroff=" Power off"
      reboot=" Reboot"
      choice="$(echo -e "$lock\n$suspend\n$hibernate\n$poweroff\n$reboot" | rofi -dmenu -i -p ' ')"
      if [ "$choice" = "$lock" ]
      then
          ~/.local/bin/lockscreen
          exit 0
      fi
      if [ "$choice" = "$suspend" ]
      then
          systemctl suspend
          exit 0
      fi
      if [ "$choice" = "$hibernate" ]
      then
          systemctl hibernate
          exit 0
      fi
      if [ "$choice" = "$poweroff" ]
      then
          systemctl poweroff
          exit 0
      fi
      if [ "$choice" = "$reboot" ]
      then
          systemctl reboot
          exit 0
      fi
    '';
    executable = true;
  };

  # Emoji picker
  xdg.dataFile."emoji".source = ./emoji;
  home.file."${config.home.homeDirectory}/.local/bin/emojipicker" = {
    text = ''
      #!/bin/sh
      chosen=$(cut -d ';' -f1 ~/.local/share/emoji | rofi -dmenu -i -p Emoji | sed "s/ .*//")
      [ -z "$chosen" ] && exit
      wtype "$chosen"
    '';
    executable = true;
  };
}
