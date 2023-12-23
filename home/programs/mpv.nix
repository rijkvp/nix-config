{ ... }: {
  programs.mpv = {
    enable = true;
    # Change the size of the subtitles
    bindings = {
      "ALT+k" = "add sub-scale +0.1";
      "ALT+j" = "add sub-scale -0.1";
    };
    config = {
      sub-auto = "all";
    };
  };
}
