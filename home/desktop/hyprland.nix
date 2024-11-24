{ config, settings, ... }:
{

  home.file."${config.home.homeDirectory}/.local/bin/nextwallpaper" = {
    text = ''
      #!/bin/sh
      swww img "$(find $XDG_PICTURES_DIR/images/wallpapers/${config.colorScheme.slug}/ -type f | shuf -n 1)"
    '';
    executable = true;
  };

  home.file."${config.home.homeDirectory}/.local/bin/togglefancy" = {
    text = ''
      #!/bin/sh
      if hyprctl getoption animations:enabled | grep -q "0"; then
        echo "Enabling fancy stuff"
        hyprctl keyword animations:enabled true
        hyprctl keyword decoration:blur:enabled true
        hyprctl keyword decoration:drop_shadow true
      else
        echo "Disabling fancy stuff"
        hyprctl keyword animations:enabled false
        hyprctl keyword decoration:blur:enabled false
        hyprctl keyword decoration:drop_shadow false
      fi
    '';
    executable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };

    extraConfig = ''
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland

      env = NIXOS_OZONE_WL = "1";
      env = ELECTRON_OZONE_PLATFORM_HINT = "wayland";

      env = GDK_BACKEND,wayland,x11
      env = GTK_USE_PORTAL,1
      env = SDL_VIDEODRIVER=wayland
      env = MOZ_ENABLE_WAYLAND,1

      env = QT_AUTO_SCREEN_SCALE_FACTOR,1
      env = QT_QPA_PLATFORM,wayland;kcb
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1

      exec-once = swww init; nextwallpaper
      exec-once = hyprctl setcursor Quintom_Ink 20
      exec-once = waybar
      exec-once = nm-applet
      exec-once = ollama serve
      exec-once = beeper --hidden

      debug {
        disable_logs = false
      }

      input {
          kb_layout = us,us
          kb_variant = ,colemak_dh
          kb_options = grp:win_space_toggle, caps:escape

          follow_mouse = 1

          touchpad {
              natural_scroll = no
          }

          sensitivity = -0.5
          repeat_rate = 50
          repeat_delay = 300
      }

      general {
          gaps_in = ${toString (settings.screenMargin / 2)}
          gaps_out = ${toString settings.screenMargin}
          border_size = 2
          col.inactive_border = rgb(${config.colorScheme.palette.base01})
          col.active_border = rgb(${config.colorScheme.palette.base0C})
          layout = master
      }
      cursor {
        inactive_timeout = 5
      }

      decoration {
        rounding = 6

        blur {
          # saves battery
          enabled = false
          size = 4
          passes = 1
          vibrancy = 0.1696
        }

        # saves battery
        drop_shadow = false
        shadow_ignore_window = true
        shadow_offset = 2 4
        shadow_range = 16
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = no

          animation = windows, 1, 7, default,
          animation = windowsOut, 1, 7, default, slide
          animation = border, 1, 6, default
          animation = borderangle, 1, 6, default
          animation = fade, 1, 3, default
          animation = workspaces, 1, 4, default
          animation = specialWorkspace, 1, 4,default, slidevert
      }

      dwindle {
        force_split = 2
      }

      master {
          no_gaps_when_only = false
      }

      gestures {
          workspace_swipe = true
      }

      misc {
        disable_hyprland_logo = true
        background_color = rgb(${config.colorScheme.palette.base00})
      }

      # KeePassXC (special workspace)
      bind = SUPER,N,togglespecialworkspace,kp
      windowrule = workspace special:kp,keepassxc
      workspace = special:kp, on-created-empty:keepassxc, gapsout:${toString settings.scratchpadMargin}

      # Scratchpad (special workspace)
      bind = SUPER,B, togglespecialworkspace, sp
      bind = SUPER_SHIFT,B, movetoworkspace, special:sp
      workspace = special:sp, on-created-empty:alacritty, gapsout:${toString settings.scratchpadMargin}

      windowrule=float,title:^debug
      windowrulev2=float,class:launcher

      # Transparent windows
      windowrule = opacity 0.9 override 0.86 override,Alacritty
      windowrule = opacity 0.87 override 0.8 override,thunar
      windowrule = opacity 0.8 override 0.8 override,keepassxc
      windowrule = opacity 0.86 override 0.86 override,Signal
      windowrule = opacity 0.8 override 0.8 override,launcher

      # Applications
      bind = SUPER, RETURN, exec, alacritty
      bind = SUPER_CTRL,W, exec, firefox
      bind = SUPER_CTRL,F, exec, thunar
      bind = SUPER_CTRL,N, exec, keepassxc
      bind = SUPER_CTRL,M, exec, alacritty -e ncmpcpp
      bind = SUPER_CTRL,K, exec, beeper
      bind = SUPER_CTRL,O, exec, obsidian

      # Application worokspaces
      windowrule = workspace 1, firefox
      windowrule = workspace 3, obsidian
      windowrule = workspace 5, Signal
      windowrule = workspace 5, Element
      windowrule = workspace 5, Beeper
      windowrule = workspace 5, whatsapp
      windowrule = workspace 6, thunderbird

      bind = SUPER, Q, killactive,
      bind = SUPER_SHIFT, X, exit,

      bind = SUPER, F, fullscreen
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
      bind = SUPER, s, exec, grim - | tee "${config.xdg.userDirs.pictures}/desktop-screenshots/$(date +"%Y-%m-%d-%H-%M-%S")-screenshot.png" | wl-copy -t image/png
      bind = SUPER SHIFT, s, exec, grim -g "$(slurp)" - | tee "${config.xdg.userDirs.pictures}/desktop-screenshots/$(date +"%Y-%m-%d-%H-%M-%S")-screenshot.png" | wl-copy -t image/png

      # Launcher menus
      bind = SUPER, D, exec, launcher -m apps
      bind = SUPER SHIFT, p, exec, ~/.local/bin/powermenu
      bind = SUPER CONTROL, l, exec, ~/.local/bin/lockscreen
      bind = SUPER, p, exec, launcher -m files
      bind = SUPER, grave, exec, ~/.local/bin/emojipicker
      bind = SUPER, C, exec, alacritty -e 
      bind = SUPER, V, exec, alacritty -e nvim 
      bind = SUPER, M, exec, ~/.local/bin/bookmarkmenu

      # Monitor backlight (make sure light is installed)
      bindel = ,XF86MonBrightnessUp, exec, light -A 5
      bindel = ,XF86MonBrightnessDown, exec, light -U 5

      # WipePlumber audio control
      bindel =, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-
      bindel =, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+
      bindl =, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      bindel = SHIFT, F2, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-
      bindel = SHIFT, F3, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+
      bindl = SHIFT, F4, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      # MPD control
      bindel  =SHIFT, F5, exec, mpc stop
      bindel = SHIFT, F6, exec, mpc prev
      bindel = SHIFT, F7, exec, mpc toggle
      bindl = SHIFT, F8, exec, mpc next

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow

      # Resize using i/o
      bind = SUPER, u, layoutmsg, orientationcycle left top
      binde =  SUPER,i,resizeactive,-16 0
      binde =  SUPER,o,resizeactive,16 0

      # Enable/disable animations/decorations
      bind = SUPER, A, exec, ${config.home.homeDirectory}/.local/bin/togglefancy
    '';
  };
}
