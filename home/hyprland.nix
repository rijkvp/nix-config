{ lib, config, theme, ... }: {

  home.file."${config.home.homeDirectory}/.local/bin/nextwallpaper" = {
    text = ''
      #!/bin/sh
      swww img "$(find $XDG_PICTURES_DIR/images/wallpapers/current/ -type f | shuf -n 1)"
    '';
    executable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };

    extraConfig = ''
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland

      env = GDK_BACKEND,wayland,x11
      env = GTK_USE_PORTAL,1
      env = SDL_VIDEODRIVER=wayland
      env = MOZ_ENABLE_WAYLAND,1

      env = QT_AUTO_SCREEN_SCALE_FACTOR,1
      env = QT_QPA_PLATFORM,wayland;kcb
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = QT_QPA_PLATFORMTHEME=qt5ct

      monitor=,preferred,auto,1
      monitor=,addreserved,0,0,36,0

      exec-once = swww init; nextwallpaper
      exec-once = hyprctl setcursor Quintom_Ink 20
      exec-once = eww daemon; eww open bar; eww open stats
      exec-once = keepassxc

      input {
          kb_layout = us

          follow_mouse = 1

          touchpad {
              natural_scroll = no
          }

          sensitivity = -0.5
          repeat_rate = 40
          repeat_delay = 400
      }
      general {
          gaps_in = 8
          gaps_out = 16
          border_size = ${theme.borderWidth}
          col.active_border = rgb(${builtins.substring 1 7 theme.borderActive})
          col.inactive_border = rgb(${builtins.substring 1 7 theme.border})

          layout = dwindle
      }

      decoration {
        rounding=${theme.rounding}
        multisample_edges = true
        inactive_opacity=0.9
        active_opacity=1
        fullscreen_opacity=1
        dim_inactive = false
        dim_strength = 0.05

        blur=true
        blur_size=4
        blur_passes=3

        drop_shadow = true
        shadow_ignore_window = true
        shadow_offset = 3 6
        shadow_range = 30
        shadow_render_power = 3
        col.shadow = rgba(00000099)
      }

      animations {
          enabled = yes

          animation = windows, 1, 7, default, slide
          animation = windowsOut, 1, 7, default, slide
          animation = border, 1, 6, default
          animation = borderangle, 1, 6, default
          animation = fade, 1, 3, default
          animation = workspaces, 1, 4, default
          animation = specialWorkspace, 1, 4,default, slidevert
      }

      dwindle {
          pseudotile = true
          preserve_split = true
      }

      master {
          no_gaps_when_only = true
      }

      gestures {
          workspace_swipe = true
      }

      # KeePassXC (special workspace)
      bind = SUPER,N,togglespecialworkspace,kp
      windowrule = workspace special:kp,keepassxc

      # Scratchpad (special workspace)
      bind = SUPER,B, togglespecialworkspace, sp
      bind = SUPER_SHIFT,B, movetoworkspace, special:sp

      windowrule=float,title:^debug

      # Transparent windows
      windowrule = opacity 0.85 override 0.8 override,Alacritty
      windowrule = opacity 0.7 override 0.7 override,thunar
      windowrule = opacity 0.8 override 0.8 override,keepassxc
      windowrule = opacity 0.86 override 0.86 override,Signal
      windowrule = opacity 0.86 override 0.86 override,whatsapp
      windowrule = opacity 0.86 override 0.86 override,Element

      # Workspace rules
      windowrule = workspace 4, firefox

      # Applications
      bind = SUPER, RETURN, exec, alacritty
      bind = SUPER_CTRL,W, exec, firefox
      bind = SUPER_CTRL,F, exec, thunar
      bind = SUPER_CTRL,N, exec, keepassxc
      bind = SUPER_CTRL,M, exec, alacritty -e ncmpcpp
      bind = SUPER_CTRL,K, exec, flatpak run org.signal.Signal
      bind = SUPER_CTRL,C, exec, flatpak run --command=thunderbird org.mozilla.Thunderbird -calendar
      bind = SUPER_CTRL,O, exec, flatpak run md.obsidian.Obsidian

      # Application worokspaces
      windowrule = workspace 3, obsidian
      windowrule = workspace 4, firefox
      windowrule = workspace 5, Signal
      windowrule = workspace 5, Element
      windowrule = workspace 5, whatsapp

      bind = SUPER_SHIFT, Q, killactive,
      bind = SUPER_SHIFT, X, exit,

      bind = SUPER, F, fullscreen
      bind = SUPER SHIFT, F, fakefullscreen
      bind = SUPER, g, togglefloating

      bind = SUPER, h, movefocus, l
      bind = SUPER, l, movefocus, r
      bind = SUPER, k, movefocus, u
      bind = SUPER, j, movefocus, d

      bind = SUPER SHIFT, h, movewindow, l
      bind = SUPER SHIFT, l, movewindow, r
      bind = SUPER SHIFT, k, movewindow, u
      bind = SUPER SHIFT, j, movewindow, d

      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, w, workspace, 4
      bind = SUPER, e, workspace, 5
      bind = SUPER, r, workspace, 6
      bind = SUPER, t, workspace, 7
      bind = SUPER, y, workspace, 8

      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, w, movetoworkspace, 4
      bind = SUPER SHIFT, e, movetoworkspace, 5
      bind = SUPER SHIFT, r, movetoworkspace, 6
      bind = SUPER SHIFT, t, movetoworkspace, 7
      bind = SUPER SHIFT, y, movetoworkspace, 8

      bind = SUPER CONTROL, 1, movetoworkspacesilent, 1
      bind = SUPER CONTROL, 2, movetoworkspacesilent, 2
      bind = SUPER CONTROL, 3, movetoworkspacesilent, 3
      # bind = SUPER CONTROL, w, movetoworkspacesilent, 4
      bind = SUPER CONTROL, e, movetoworkspacesilent, 5
      bind = SUPER CONTROL, r, movetoworkspacesilent, 6
      bind = SUPER CONTROL, t, movetoworkspacesilent, 7
      bind = SUPER CONTROL, y, movetoworkspacesilent, 8
  
      # Next wallpaper
      bind = SUPER_CTRL,V, exec, nextwallpaper

      # Screenshot
      bind = SUPER, s, exec, grim - | tee "${config.xdg.userDirs.pictures}/$(date +"%Y-%m-%d-%H:%M:%S")-screenshot.png" | wl-copy -t image/png
      bind = SUPER SHIFT, s, exec, grim -g "$(slurp)" - | tee "${config.xdg.userDirs.pictures}/$(date +"%Y-%m-%d-%H:%M:%S")-screenshot.png" | wl-copy -t image/png

      # dmenu menus (using rofi)
      bind = SUPER, D, exec, rofi -show drun -i
      bind = SUPER SHIFT, p, exec, ~/.local/bin/powermenu
      bind = SUPER, p, exec, xdg-open "$(fd -t f | rofi -dmenu -i -p ' ')"
      bind = SUPER SHIFT, p, exec, ~/.local/bin/powermenu
      bind = SUPER, grave, exec, ~/.local/bin/emojipicker
      bind = SUPER, C, exec, rofi -modi calc -show calc -no-show-match -no-sort -calc-command 'wtype "{result}"'

      bind = SUPER CONTROL, l, exec, ~/.local/bin/lockscreen

      # Monitor backlight (make sure light is installed)
      bindel = ,XF86MonBrightnessUp, exec, light -S "$(light -G | awk '{ print int(($1 + .72) * 1.4) }')"
      bindel = ,XF86MonBrightnessDown, exec, light -S "$(light -G | awk '{ print int($1 / 1.4) }')"

      # WipePlumber audio control
      bindel=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-
      bindel=, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+
      bindl=, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      bindel=SHIFT, F2, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-
      bindel=SHIFT, F3, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+
      bindl=SHIFT, F4, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      # MPD control
      bindel=SHIFT, F5, exec, mpc stop
      bindel=SHIFT, F6, exec, mpc prev
      bindel=SHIFT, F7, exec, mpc toggle
      bindl=SHIFT, F8, exec, mpc next

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow

      # Resize using i/o
      binde =  SUPER,i,resizeactive,-16 0
      binde =  SUPER,o,resizeactive,16 0
    '';
  };
}
