{ ... }:
{
  programs.zathura = {
    enable = true;
    options = {
      adjust-open = "best-fit";
      page-padding = 1;
      guioptions = "v";
      recolor-keephue = "true";
      selection-clipboard = "clipboard";
    };
    mappings = {
      u = "scroll half-up";
      d = "scroll half-down";
      D = "toggle_page_mode";
      r = "reload";
      R = "rotate";
      O = "zoom in";
      I = "zoom out";
      "<C-p>" = "print";
    };
  };
}
