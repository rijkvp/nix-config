{ pkgs, inputs, config, ... }: {
  programs.joshuto.enable = true;
  xdg.configFile."joshuto/joshuto.toml".text = ''
    numbered_command = false

    use_trash = true
    watch_files = true
    xdg_open = true
    xdg_open_fork = true

    [display]
    # default, hsplit
    mode = "default"

    automatically_count_files = false
    collapse_preview = true
    # ratios for parent view (optional), current view and preview
    column_ratio = [1, 4, 4]
    scroll_offset = 6
    show_borders = true
    show_hidden = false
    show_icons = true
    tilde_in_titlebar = true
    # none, absolute, relative
    line_number_style = "none"

    [display.sort]
    # lexical, mtime, natural
    method = "natural"
    case_sensitive = false
    directories_first = true
    reverse = false

    [preview]
    max_preview_size = 2097152 # 2MB
    preview_script = "~/.local/bin/fm-preview"

    [tab]
    # inherit, home, root
    home_page = "home"
  '';
  home.file."${config.home.homeDirectory}/.local/bin/fm-preview" = {
    text = ''
      #!/bin/sh
      bat --color=always --paging=never --style=plain "$2" 
    '';
    executable = true;
  };
}
