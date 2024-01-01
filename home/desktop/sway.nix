{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      bars = [ ];
      startup = [{
        command = "waybar";
        always = true;
      }];
    };
  };
}
