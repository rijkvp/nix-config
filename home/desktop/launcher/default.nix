{ config, ... }: {
  home.file."${config.home.homeDirectory}/.local/bin/powermenu" = {
    text = ''
      #!/bin/sh
      lock=" Lock"
      suspend="󰒲 Suspend"
      hibernate="󰤄 Hibernate"
      poweroff=" Power off"
      reboot=" Reboot"
      choice="$(echo -e "$lock\n$suspend\n$hibernate\n$poweroff\n$reboot" | launcher -d -p 'Power menu  ')"
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
      chosen=$(cut -d ';' -f1 ~/.local/share/emoji | launcher -d -p "Emojis" | sed "s/ .*//")
      [ -z "$chosen" ] && exit
      wtype "$chosen"
    '';
    executable = true;
  };

  # Bookmark menu
  home.file."${config.home.homeDirectory}/.local/bin/bookmarkmenu" = {
    text = ''
      #!/bin/sh
      grep -vE '^(#|$)' ~/docs/BOOKMARKS | launcher -d -p "Bookmarks" | grep -oE '[^ ]+$' | wtype -
    '';
    executable = true;
  };
}
