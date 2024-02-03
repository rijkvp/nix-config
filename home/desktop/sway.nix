{ pkgs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      bars = [ ];
      startup = [{
        command = "waybar";
        always = true;
      }];
      keybindings = pkgs.lib.mkOptionDefault {
        "Mod4+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
        "Mod4+q" = "kill";
      };
    };
  };
}
