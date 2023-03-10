{ lib, config, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    extraConfig = ''
      exec-once = hyprctl setcursor Quintom_Ink 24
      exec-once = swaybg -i ~/pics/images/wallpapers/wallpaper.jpg
      exec-once = keepassxc
      exec-once = waybar

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
          gaps_in = 5
          gaps_out = 20
          border_size = 2
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          layout = dwindle
      }

      decoration {
          rounding = 7
          blur = yes
          blur_size = 5
          blur_passes = 1

          drop_shadow = yes
          shadow_range=20
          shadow_render_power=3
          shadow_ignore_window=1
          shadow_offset= 8 8
          col.shadow=0x44000000
      }

      animations {
          enabled = yes

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      dwindle {
          pseudotile = yes
          preserve_split = yes
      }

      master {
          new_is_master = true
      }

      gestures {
          workspace_swipe = true
      }

      # KeePassXC special workspace
      bind = SUPER,N,togglespecialworkspace,kp
      windowrule = workspace special:kp,keepassxc

      # Transparent windows
      windowrule = opacity 0.8 override 0.8 override,Alacritty
      windowrule = opacity 0.7 override 0.7 override,thunar
      windowrule = opacity 0.8 override 0.8 override,keepassxc
      windowrule = opacity 0.86 override 0.86 override,Signal
      windowrule = opacity 0.86 override 0.86 override,whatsapp
      windowrule = opacity 0.86 override 0.86 override,Element
      windowrule = opacity 0.8 override 0.8 override,zathura

      # Workspace rules
      windowrule = workspace 4, firefox

      # Applications
      bind = SUPER, RETURN, exec, alacritty
      bind = SUPER_CTRL,W, exec, firefox
      bind = SUPER_CTRL,F, exec, thunar
      bind = SUPER_CTRL,N, exec, keepassxc
      bind = SUPER_CTRL,M, exec, alacritty -e ncmpcpp

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

      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, w, movetoworkspace, 4
      bind = SUPER SHIFT, e, movetoworkspace, 5
      bind = SUPER SHIFT, r, movetoworkspace, 6

      bind = SUPER CONTROL, 1, movetoworkspacesilent, 1
      bind = SUPER CONTROL, 2, movetoworkspacesilent, 2
      bind = SUPER CONTROL, 3, movetoworkspacesilent, 3
      # bind = SUPER CONTROL, w, movetoworkspacesilent, 4
      bind = SUPER CONTROL, e, movetoworkspacesilent, 5
      bind = SUPER CONTROL, r, movetoworkspacesilent, 6
  
      # Screenshot
      bind = SUPER, s, exec, grim - | tee "$xdg_pictures_dir/$(date +"%y-%m-%d-%h:%m")-screenshot.png" | wl-copy -t image/png
      bind = SUPER SHIFT, s, exec, grim -g "$(slurp)" - | tee "$xdg_pictures_dir/$(date +"%y-%m-%d-%h:%m")-screenshot.png" | wl-copy -t image/png

      # dmenu menus (using rofi)
      bind = SUPER, D, exec, rofi -show drun -i -p Applications
      bind = SUPER SHIFT, p, exec, ~/.local/bin/powermenu
      bind = SUPER, p, exec, xdg-open $(rg --files | rofi -dmenu -i -p Files)
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
