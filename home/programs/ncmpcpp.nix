{ ... }:
{
  programs.ncmpcpp = {
    enable = true;
    settings = {
      user_interface = "alternative";
    };
    bindings = [
      # Vim-like keybindings for ncmpcpp
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "J";
        command = [
          "select_item"
          "scroll_down"
        ];
      }
      {
        key = "K";
        command = [
          "select_item"
          "scroll_up"
        ];
      }
      {
        key = "h";
        command = "previous_column";
      }
      {
        key = "l";
        command = "next_column";
      }
      {
        key = "n";
        command = "next";
      }
      {
        key = "N";
        command = "next";
      }
      {
        key = "i";
        command = "seek_backward";
      }
      {
        key = "o";
        command = "seek_forward";
      }
      {
        key = "space";
        command = "pause";
      }
      {
        key = "x";
        command = "delete_playlist_items";
      }
      {
        key = "c";
        command = "clear_playlist";
      }
      {
        key = "a";
        command = "add_item_to_playlist";
      }
      # Menus
      {
        key = "p";
        command = "show_playlist";
      }
      {
        key = "m";
        command = "show_media_library";
      }
      {
        key = "t";
        command = "show_tag_editor";
      }
      {
        key = "f";
        command = "show_browser";
      }
      {
        key = "v";
        command = "show_visualizer";
      }
    ];
  };
}
